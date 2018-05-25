/**
 * Contains all the methods for the context menu and all of its
 * other functionality that is contained within, such as changing of
 * color, title, file and removing of a button
 */

 /**Holds the action that is currently being performed, for example, changing title */
 var currentContextAction = "";
 const CHANGE_TITLE = 0;
 const CHANGE_MUSIC = 1;
 const CHANGE_COLOR = 2;
 const REMOVE_BUTTON = 3;
 /**Holds the item that is currently being contexted */
 var currentContextItem;
/**This object holds the data associated with the current action, depends on action type */
 var currentContextData;

/**
 * Requests the context menu to be shown for this element
 * @param {HTMLElement} element the elemtn that was right clicked
 */
function showContextmenu(element){
    //See if we were working on something
    if(currentContextItem){
        cancelCurrentAction();
    }else{
        currentContextItem = element;
    }
    //Get the coords of the current element
    var offset = $(element).offset();
    offset.top += $(element).outerHeight();
    //fadeIn the contextMenu
    $('#contextmenu').fadeIn(100).offset(offset);

    //Add a listener to the body instead of document to fadeout if we click somewhere else
    //The document listener is already taken by BS4 dropdownitem
    $('body').unbind('click').click(function(){
        currentContextItem = undefined;
        hideContextMenu();
        cancelCurrentAction();
    });

    //Add the listeners for the functionality
    $('#changeTitle').unbind('click').click(function(ev){
        //Set the action
        currentContextAction = CHANGE_TITLE;
        //Get the id of the target
        var bId = currentContextItem.id.replace('Button', '');
        //Hide the menu, we're done with it
        hideContextMenu();
        //Prevent the click from triggering other stuff
        ev.stopPropagation();
        //Set the button to editable and add event listeners
        var buttonTitle = $(element).find('.buttonTitle');
        buttonTitle.attr('contentEditable', 'true').focus();
        buttonTitle.unbind('blur').blur(function(){
            cancelCurrentAction();
        });
        //Save the original button text for future reference
        var origTitle = buttonTitle.text();
        currentContextData = {'orig': origTitle, 'buttonTitle': buttonTitle};
        buttonTitle.keydown(function(event){
            //If you press enter, you save your title change, else it doesn't work
            if(event.keyCode == 13){
                event.stopPropagation();
                currentContextData.orig = buttonTitle.text();
                //Now that the title has been changed, find the matching track object
                $.each(tracks, function(index, track){
                    if(track.id == bId){//We found the one
                        track.title = currentContextData.orig;
                        saveTracksToFile(settings.get('mostRecent'));
                    }
                });
                cancelChangeTitle(currentContextData);
            }
        });
    });

    //Add the listener for changeColor functionality
    $('#changeColor').unbind('click').click(function(ev){
        //Set the action
        currentContextAction = CHANGE_COLOR;
        //Get the id of the target
        var bId = "#" + currentContextItem.id;
        //Hide the menu, we're done with it
        hideContextMenu();
        //Prevent the click from triggering other stuff
        ev.stopPropagation();
        //Get the current Color
        const cColor = $(bId).attr('style').replace('background-color:', '').replace(';', '');
        //Show the colorPicker and set it to the currentcolor
        $('#colorPicker').val(cColor).click();
        $('#colorPicker').unbind('change').change(function(){
            //Change the color in the dom
            const color = $('#colorPicker').val();
            $(bId).attr('style', 'background-color:' + color + ";");
            //Now save it in the tracks array and write to disk
            bId = bId.replace('#', '').replace('Button', '');
            $.each(tracks, function(index, track){
                if(track.id == bId){
                    track.backgroundColor = color;
                    //After the right track has been changed, let's save the result
                    saveTracksToFile(settings.get('mostRecent'));
                }
            });

        });
    });

    //Add the listener for the removeButton functionality
    $('#removeButton').unbind('click').click(function(ev){
        //Set the action
        currentContextAction = REMOVE_BUTTON;
        //Get the id of the target
        var bId = "#" + currentContextItem.id;
        //Hide the menu, we're done with it
        hideContextMenu();
        //Prevent the click from triggering other stuff
        ev.stopPropagation();
        //Show the confirmation button
        showRemoveConfirmation(function(buttonIndex){
            if(buttonIndex == 0){
                //Remove the button
                $(bId).parent().remove();
                //Now also remove the button from the tracks list
                bId = bId.replace('Button', '').replace('#', '');
                var foundIndex = -1;
                $.each(tracks, function(index, track){
                    if(track.id == bId){
                        foundIndex = index;
                    }
                });
                //Remove the found Index
                tracks.splice(foundIndex, 1);
                //Save back to disk
                saveTracksToFile(settings.get('mostRecent'));
            }else{
                //Don't remove the button, do nothing
            }
        });
    });
}

/**
 * Hides the context menu, either after cancelling an action or choosing an action
 */
function hideContextMenu(){
    $('#contextmenu').fadeOut(100);
    $('body').unbind('click');
    currentContextItem = undefined;
}

/**
 * Cancels the editing project and restores the original state
 * @param {Object} data 
 */
function cancelChangeTitle(data){
    data.buttonTitle.unbind('keydown');
    data.buttonTitle.attr('contentEditable', 'false');
    data.buttonTitle.html(data.orig);
}

/**
 * Cancels the actions we're currently trying to do
 */
function cancelCurrentAction(){
    //Cancel the action depending on the type of action
    switch(currentContextAction){
        case CHANGE_TITLE:
            cancelChangeTitle(currentContextData);
        break;
        case CHANGE_MUSIC:
        break;
        case CHANGE_COLOR:
        break;
        case REMOVE_BUTTON:
        break;
    }
    hideContextMenu();
}
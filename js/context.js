/**
 * Contains all the methods for the context menu and all of its
 * other functionality that is contained within, such as changing of
 * color, title, file and removing of a button
 */
/**
 * Requests the context menu to be shown for this element
 * @param {HTMLElement} element the elemtn that was right clicked
 */
function showContextmenu(element){
    //Get the coords of the current element
    var offset = $(element).offset();
    offset.top += $(element).outerHeight();
    //fadeIn the contextMenu
    $('#contextmenu').fadeIn(100).offset(offset);

    //Add a listener to the body instead of document to fadeout if we click somewhere else
    //The document listener is already taken by BS4 dropdownitem
    $('body').unbind('click').click(function(){
        $('#contextmenu').fadeOut(100);
        $('body').unbind('click');
    });
}
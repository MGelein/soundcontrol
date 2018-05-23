/**Require access to the file dialogs from the system*/
const {dialog} = require('electron').remote;
const {resolve, basename} = require('path');

/**The file type filter for the loading of files in this application */
const filters = [
    {name: 'SoundControl CSV', extensions: ['csv']}
];

/**
 * Shows the standard load/open dialog, at least, 'standard'
 * for this application.
 * @param {Function} callback the function that is called once files have been seleted. Param is filename array.
 */
function showOpenDialog(callback){
    var mRecent = settings.get('mostRecent');
    mRecent = mRecent.replace(basename(mRecent), '');
    dialog.showOpenDialog({
        title: "Load a SoundControl CSV file",
        defaultPath: resolve(mRecent),
        "filters": filters,
        properties: ["openFile"]
    }, callback);
}
/**
 * Shows the standard save dialog for SoundControl
 * @param {Function} callback is called once the file has been selected for saving. Param is filneames array
 */
function showSaveDialog(callback){
    var mRecent = settings.get('mostRecent');
    mRecent = mRecent.replace(basename(mRecent), '');
    dialog.showSaveDialog({
        title: "Save a SoundControl CSV file",
        defaultPath: resolve(mRecent),
        "filters": filters,
    }, callback);
}

/**
 * Called when the load button is clicked
 */
function handleLoadButton(){
    showOpenDialog(function(filepaths){
        //Start loading the file
        if(filepaths && filepaths.length > 0) loadTrackdata(filepaths[0]);
    });
}

/**
 * Called when the save button is pressed
 */
function handleSaveButton(){
    showSaveDialog(function(filepaths){
        //Convert the tracks array into a CSV file
        var content = "";
        $.each(tracks, function(index, track){
            content += track.backgroundColor + ", " + track.title + ", " + track.file + ", " + track.start + "\n";
        });
        //Now save that content to the provided filepath if it is valid
        if(filepaths && filepaths.length > 0){
            fs.writeFile(filepaths, content, function(err){
                if(!err) console.log("File saved succesfully: " + filepaths);
                else console.log("Something went wrong trying to save the file: " + filepaths);
            }); 
        }
    });
}
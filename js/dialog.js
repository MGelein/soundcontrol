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
        console.log(filepaths);
    });
}

/**
 * Called when the save button is pressed
 */
function handleSaveButton(){
    showSaveDialog(function(filepaths){
        console.log(filepaths);
    });
}
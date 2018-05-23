/**Require access to the file dialogs from the system*/
const {dialog} = require('electron').remote;

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
    dialog.showOpenDialog({
        title: "Load a SoundControl CSV file",
        defaultPath: "data",
        "filters": filters,
        properties: ["openFile"]
    }, callback);
}

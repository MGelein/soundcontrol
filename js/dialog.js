/**Require access to the file dialogs from the system*/
const { dialog } = require('electron').remote;
const { resolve, basename } = require('path');

/**The file type filter for the loading of files in this application */
const filters = [
    { name: 'SoundControl CSV', extensions: ['csv'] }
];
/**The file type filter for the loading of music files */
const music_filters = [
    { name: 'SoundControl Music', extensions: ['mp3', 'wav', 'wma', 'ogg'] }
];

/**
 * Shows the standard load/open dialog, at least, 'standard'
 * for this application.
 * @param {Function} callback the function that is called once files have been seleted. Param is filename array.
 */
function showOpenDialog(callback) {
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
 * Shows the music file loading dialog.
 * @param {Function} callback 
 */
function showLoadMusicDialog(callback, file) {
    var mRecent = settings.get('mostRecent');
    if(file) mRecent = file;//If we are replacing a previous file, show that location
    mRecent = mRecent.replace(basename(mRecent), '');
    dialog.showOpenDialog({
        title: "Load a SoundControl Music File",
        defaultPath: resolve(mRecent),
        "filters": music_filters,
        properties: ["openFile"]
    }, callback);
}

/**
 * Shows the standard save dialog for SoundControl
 * @param {Function} callback is called once the file has been selected for saving. Param is filneames array
 */
function showSaveDialog(callback) {
    var mRecent = settings.get('mostRecent');
    mRecent = mRecent.replace(basename(mRecent), '');
    dialog.showSaveDialog({
        title: "Save a SoundControl CSV file",
        defaultPath: resolve(mRecent),
        "filters": filters,
    }, callback);
}

/**
 * This function shows the confirmation dialog after you indicated
 * you want to remove a button
 */
function showRemoveConfirmation(callback){
    dialog.showMessageBox({
        title: "SoundControl: Are You Sure?",
        message: "Are you sure you want to remove this button? This cannot be undone!",
        buttons: ["Yes", "No"]
    }, callback);
}

/**
 * Called when the load button is clicked
 */
function handleLoadButton() {
    showOpenDialog(function (filepaths) {
        //Start loading the file
        if (filepaths && filepaths.length > 0) loadTrackdata(filepaths[0]);
    });
}

/**
 * Called when the save button is pressed
 */
function handleSaveButton() {
    showSaveDialog(function (filepaths) {
        //Now save that content to the provided filepath if it is valid
        if (filepaths && filepaths.length > 0) {
           saveTracksToFile(filepaths);
        }
    });
}

/**
 * Saves the tracks array as a CSV to the provided location on disk
 * @param {String} url 
 */
function saveTracksToFile(url, callback) {
    //Convert the tracks array into a CSV file
    var content = "";
    $.each(tracks, function (index, track) {
        content += track.backgroundColor + "\t" + track.title + "\t" + track.file + "\t" + track.start + "\n";
    });
    //Now write the file to the URL
    fs.writeFile(url, content, function (err) {
        if(callback) callback();
        if (!err) console.log("File saved succesfully: " + url);
        else console.log("Something went wrong trying to save the file: " + url);
    });
}

/**
 * This function is called when the addMusicButton is clicked.
 */
function handleAddMusicButton() {
    showLoadMusicDialog(function (filepaths) {
        //Now that we have a filepath, start creating a new
        //empty track
        let track = {};
        track.backgroundColor = "#CC3300";
        track.title = "New";
        track.file = filepaths[0];
        track.start = -1;
        track.id = basename(resolve(track.file)).replace(/.mp3/g, '').replace(/.wav/g, '')
        .replace(/.ogg/g, '').replace(/.wma/g, '').replace(/[^a-z0-9]/gmi, '');//Lastly also remove any special characters
        //And push it to the list of tracks
        tracks.push(track);

        //Now save and reload
        saveTracksToFile(settings.get('mostRecent'), function(){
            loadTrackdata(settings.get('mostRecent'));
        });
    });
}
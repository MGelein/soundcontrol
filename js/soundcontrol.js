"use strict";

/***If we are currently playing any audio. Set to false in init */
var playing = false;

/**The different fade speeds, before they are overwritten by the settings INI */
var SLOW_FADE = 0.03;
var MED_FADE = 0.1;
var FAST_FADE = 0.25;

/**The component Templates */
var audioTemplate = "";
var buttonTemplate = "";

/**Link to Node JS filesystem */
var fs = require("fs");

/**
 * Entry point
 */
$(document).ready(function(){
    //Initially, read the two templates into memore
    audioTemplate = $('#audioTemplate').html();
    $('#audioTemplate').remove();
    buttonTemplate = $('#buttonTemplate').html();
    $('#buttonTemplate').remove();

    //First parse the track data
    fs.readFile("data/tracks.csv", "utf-8", function(err, data){
        parseTrackData(data);
        //Then prepare to start
        init();
        setInterval(update, 100);
    })

});


/**List of tracks */
var tracks = [];
/**
 * Starts loading the track data from the hidden embedded iframe
 */
function parseTrackData(data){
    //Read the data and split the lines, every line is a track
    var lines = data.split("\n");

    //Now go through every line and create a track object
    $.each(lines, function(index, line){
        if(line.length < 4) return; //Ignore, not long enough to matter
        if(line.indexOf(',') == -1) return;//Ignore, no comma's in this line
        if(line.indexOf('//') == 0) return;//Ignore, this line is a comment

        //Split the lines into parts and count the parts
        var parts = line.split(',');
        if(parts.length != 4) return;//Ignore, not enough parts

        //Now start reading the parts
        var track = {};
        track.backgroundColor = parts[0].trim();
        track.title = parts[1].trim();
        track.file = parts[2].trim();
        track.start = Number(parts[3].trim());
        track.id = track.file.replace(/.mp3/g, '').replace(/.wav/g, '').replace(/.ogg/g, '').replace(/.wma/g, '');
        //And push it to the list of tracks
        tracks.push(track);
    });

    //Make all the necessary HTML ellemtns for all the tracks
    var audioHTML = "";
    var buttonHTML = "";
    $.each(tracks, function(index, track){
        //Create the audioTrack element and add it to the HTML
        var audioTrack = audioTemplate.replace(/%ID%/g, track.id);
        audioTrack = audioTrack.replace(/%FILE%/g, track.file);
        audioTrack = audioTrack.replace('source file="', 'source src="');
        audioHTML += audioTrack;

        //Create the button element and add it to the HTML
        var button = buttonTemplate.replace(/%ID%/g, track.id);
        button = button.replace(/%TITLE%/g, track.title);
        button = button.replace(/START/g, track.start);
        buttonHTML += button;
    });
    //Now add all the HTML to the DOM
    $('#audioHolder').html(audioHTML);
    $('#buttonHolder').append(buttonHTML);

    //With the HTML added to the DOM we can finally make the BG color adjustments
    $.each(tracks, function(index, track){
        $('#' + track.id + "Button").attr('style', 'background-color:' + track.backgroundColor + ';');
    });
}

/**
 * Called to reset all audio parameters and be ready to start
 */
function init(){
    //Stop playing all files just to be sure
    console.log($('audio'));
    $('audio').each(function(index, track){
        track.currentTime = 0;
        track.volume = 0;
        track.targetVolume = 0;
        playing = false;
    });

    //Re-set the handler for the fadeButtons
    $('.fadeButton').unbind('click').click(function(){
        //What to do on a click, first remove any selection made visible
        $('.fadeButton').removeClass('btn-primary btn-secondary').addClass('btn-secondary');
        //Then make the new button primary button
        $(this).addClass('btn-primary').removeClass('btn-secondary');

        //Now determine which button was clicked
        switch($(this).attr('id')){
            case 'slowFade':
                volumeEaseFactor = SLOW_FADE;
            break;
            case 'fastFade':
                volumeEaseFactor = FAST_FADE;
            break;
            case 'mediumFade':
                volumeEaseFactor = MED_FADE;
            default:
            break;
        }
    });
}

var noVolume = '<i class="fas fa-volume-off"></i>';
var halfVolume = '<i class="fas fa-volume-down"></i>';
var fullVolume = '<i class="fas fa-volume-up"></i>';

//Used to handle animation frames, the FPS of animations is waay below the FPS for audio fades. (a 1/3 to be exact);
var frameCounter = 0;

/**The default volume ease factor is 0.1, this is a medium fade */
var volumeEaseFactor = MED_FADE;

/**
 * Update handler, will handle audio automation animation and easing
 */
function update(){
    $('audio').each(function(index, track){
        var diff = track.targetVolume - track.volume;
        if(Math.abs(diff) < 0.01) track.volume = track.targetVolume;
        track.volume = constrain(track.volume + diff * volumeEaseFactor, 0, 1);
    });
    frameCounter ++;
    if(frameCounter > 1){
        frameCounter = 0;
        updateIcons();
    }
}

/**
 * Updates the icons, this is done a little les frequently to prevent DOM updates
 */
function updateIcons(){
    $('audio').each(function(index, track){
        //Set icon according to track volume
        var volumeID = '#' + track.id.replace(/Sound/g, '') + "Volume";
        var icon = track.volume < 0.1 ? noVolume : track.volume < 0.5 ? halfVolume : fullVolume;
        var opacity = track.volume * 0.8 + 0.2;
        var fontweight = track.volume * 400 + 400;
        $(volumeID).html(icon).attr('style', 'opacity: ' + opacity + ";font-weight: " + fontweight);
    });              
}

/**
 * Starts to play the provided track, fades others
 * @param {Track} track 
 * @param {Number} seconds to start at, undefined or -1 to start at currentPos
 */
function playTrack(track, startPos){
    if(!playing){
        //If we are not playing yet, first play all tracks
        $('audio').each(function(index, track){ track.play();});
    }
    //Now set all targetVolumes to 0
    $('audio').each(function(index, track){ track.targetVolume = 0;});

    //Only allow the chosen one to play
    var chosenTrack = $('#' + track + "Sound").get(0);
    chosenTrack.targetVolume = 1;
	if(startPos && startPos != -1){
		chosenTrack.currentTime = startPos;
	}
}

/**
 * REturns the constrained value between min and max
 */
function constrain(val, min, max){
    return Math.max(Math.min(max, val), min);
}
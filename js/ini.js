const fs = require("fs");
/**
 * Creates a new queryable Ini object from the provided UTF-8 parsed ini file.
 * @param {String} data 
 */
function Ini(data){
    /**This is the original data as loaded from disk */
    this.data = data;
    /**This is the data split by lines */
    this.lines = data.split("\n");
    /**This object will hold the key value data */
    this.holder = {};

    //Go through every line and add a key value pair to holder if appropriate
    for(var i = 0; i < this.lines.length; i++){
        //Check if this line is a comment
        if(this.lines[i].substr(0, 1) == "#" || this.lines[i].substr(0, 2) == "//") continue;
        //Check if this line is empty or doesn't contain an equals sign
        if(this.lines[i].indexOf("=") == -1 || this.lines[i].length < 2) continue;
        //If we made it to here this is a valid key-value pair
        const parts = this.lines[i].split("=");
        this.holder[parts[0].trim()] = parts[1].trim();
    }

    /**
     * Tries to find the appropriate key in this ini and returns the value.
     * Returns undefined if not defined (duh).
     * @param {String} key 
     */
    this.get = function(key){
        return this.holder[key];
    }

    /**
     * Sets the provided key to the provided value
     * @param {String} key 
     * @param {Any} value 
     */
    this.set = function(key, value){
        this.holder[key] = value;
    }

    /**
     * Returns a String representation of the object for saving
     */
    this.toString = function(){
        const keys = Object.keys(this.holder);
        var result = "";
        for(var i = 0; i < keys.length; i++){
            result += keys[i] + "=" + this.holder[keys[i]] + "\n";
        }
        return result;
    }

    /**
     * Tries to save the ini file to the provided location
     * @param {String} url 
     */
    this.save = function(url){
        fs.writeFile(url, this.toString(), function(err){
            if(!err) console.log("Settings file saved succesfully");
            else console.log("Settings file saved with issues: ", err);
        });
    }

}
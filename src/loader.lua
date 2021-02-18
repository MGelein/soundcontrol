loader = {}
loader.acceptedFormats = {'.mp3', '.wav', '.ogg'}
loader.dir = ''

function loader.getFileNames()
    local fused = love.filesystem.isFused()
    local files = {}
    if fused then
        local dir = love.filesystem.getSourceBaseDirectory()
        love.filesystem.mount(dir, 'localFiles')
        loader.dir = 'localFiles'
    end
    files = love.filesystem.getDirectoryItems(loader.dir)
    return files
end

function loader.getMusicFiles(files)
    local files = loader.getFileNames()
    local musicFiles = {}
    for i, f in ipairs(files) do
        if string.sub(f, 1, 1) ~= '.' and loader.isAcceptedFileFormat(f) then
            table.insert(musicFiles, f) 
        end
    end
    return musicFiles
end

function loader.isAcceptedFileFormat(file)
    for i, format in ipairs(loader.acceptedFormats) do
        if string.find(file, format) then return true end
    end
    return false
end

local currentContentManager

---@class ContentManager : Class
ContentManager = class{

    create = function( self )
        if currentContentManager then
            error( "Content manager exists", 2)
        end

        currentContentManager = self
    end;

    destroy = function()
        currentContentManager = nil
    end;

    isWorldDownloaded = function()

    end;

    downloadWorld = function()

    end;


	download = function( self )
		local resul
		resul = downloadFile( self.mapPath )
		for i = 1, #self.imgs do
			resul = resul and downloadFile( self.imgs[i] )
		end

		if resul then
			self:addEventHandler( 'onClientFileDownloadComplete', self.resourceRoot, self.onFileDownloadComplecte )
		else
			outputDebugString( string.format( 'Can not download whole world "%s" from resource "%s"', self.name, self.resource:getName() ), 2 )
		end

		return resul
	end;

	onFileDownloadComplecte = function( self, fileName )
		local fileName = string.format( ':%s/%s', self.resource:getName(), fileName )
		if fileName == self.mapPath then
			self.downloadState.map = true
		else
			local imgIndex = table.find( self.imgs, fileName )
			if imgIndex then
				self.downloadState.imgs[imgIndex] = true
			end
		end


		local isAllDownloaded = self.downloadState.map
		for i = 1, #self.imgs do
			if self.downloadState.imgs[i] then
			else
				isAllDownloaded = false
				break
			end
		end

		if isAllDownloaded then
			self:onDownload()
		end
	end;

	onDownload = function( self )
		self:removeEventHandler( 'onClientFileDownloadComplete', self.resourceRoot, self.onFileDownloadComplecte )
		self.isDownloaded = true
		triggerEvent( 'World:onDownload', self.resourceRoot, self.name )
		if self.loadInDimensionAfterDownload then
			self:load( self.loadInDimensionAfterDownload )
			self.loadInDimensionAfterDownload = nil
		end
	end;

	delete = function( self )
		local exists = File.exists
		local delete = File.delete

		if exists( self.mapPath ) then
			delete( self.mapPath )
		end
		for i = 1, #self.imgs do
			if exists( self.imgs[i] ) then
				delete( self.imgs[i] )
			end
		end

		self.downloadState = {
			map = false;
			imgs = {};
		}

		self.isDownloaded = false;

		return true
	end;
}
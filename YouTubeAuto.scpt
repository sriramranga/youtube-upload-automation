on adding folder items to this_folder after receiving added_items
	repeat with theItem in added_items
		try
			set itemInfo to info for theItem
			set fileName to name of itemInfo
			
			-- Check if video file (case insensitive)
			set lowerName to do shell script "echo " & quoted form of fileName & " | tr '[:upper:]' '[:lower:]'"
			
			if lowerName ends with ".mp4" or lowerName ends with ".mov" or lowerName ends with ".avi" or lowerName ends with ".mkv" or lowerName ends with ".flv" or lowerName ends with ".wmv" or lowerName ends with ".webm" or lowerName ends with ".m4v" then
				
				-- Wait for AirDrop to complete
				delay 5
				
				-- Move file to airdropVideos
				tell application "Finder"
					set targetFolder to (path to home folder as text) & "Documents:personalAutomation:youtubeUpload:airdropVideos:"
					try
						move theItem to folder targetFolder
						
						-- File moved successfully, wait longer for filesystem to sync
						delay 5
						display notification "Starting upload..." with title "YouTube"
						do shell script "bash ~/Documents/personalAutomation/youtubeUpload/handle_upload.sh > /dev/null 2>&1 &"
						
					on error
						-- File already exists, skip
					end try
				end tell
				
			end if
		end try
	end repeat
end adding folder items to

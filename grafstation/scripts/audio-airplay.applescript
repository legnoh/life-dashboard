-- inspired by switchaudio-osx
-- https://github.com/deweller/switchaudio-osx/issues/9#issuecomment-1732549848

property airPlayDevice : "${AUDIO_OUTPUT_AIRPLAY}"
property localDevice : "${AUDIO_OUTPUT_LOCAL}"

global initialApplication, initialWindow, currentAudioSource, availableAudioSources

set the currentAudioSource to (do shell script "/opt/homebrew/bin/SwitchAudioSource -c")
set the availableAudioSources to paragraphs of (do shell script "/opt/homebrew/bin/SwitchAudioSource -a")

if currentAudioSource is equal to localDevice then
	if availableAudioSources contains "Airplay" then
		switchToDevice("Airplay")
	else
		connectToAirPlayDevice()
	end if
else
	switchToDevice(localDevice)
end if

-- Switch the current device using switchaudio-osx.
on switchToDevice(device)
	do shell script "/opt/homebrew/bin/SwitchAudioSource -s " & quoted form of device
end switchToDevice


-- Connect to the desired AirPlay device.
on connectToAirPlayDevice()
	openAudioDevices()
	tell application "System Events" to tell application process "Audio MIDI Setup"
		click menu button 1 of splitter group 1 of window "Audio Devices"
		click menu item "Connect AirPlay Device" of menu 1 of menu button 1 of splitter group 1 of window "Audio Devices"
		set the availableDevice to "No AirPlay devices available"
		repeat while availableDevice is "No AirPlay devices available"
			set availableDevice to name of first menu item of menu 1 of menu item "Connect AirPlay Device" of menu 1 of menu button 1 of splitter group 1 of window "Audio Devices"
		end repeat
		click (menu item airPlayDevice of menu 1 of menu item "Connect AirPlay Device" of menu 1 of menu button 1 of splitter group 1 of window "Audio Devices")
	end tell
	delay 5
	tell application "Audio MIDI Setup" to quit
end connectToAirPlayDevice


-- Open and focus Audio Devices
on openAudioDevices()
	tell application "Audio MIDI Setup"
		reopen
		activate
	end tell
	tell application "System Events"
		repeat until (exists window "Audio Devices" of application process "Audio MIDI Setup")
			delay 0.01
		end repeat
	end tell
end openAudioDevices

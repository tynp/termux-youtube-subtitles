# termux-youtube-subtitles
Share a youtube video to Termux and download its subtitles.

This bash script installs a [termux-url-opener](https://wiki.termux.com/wiki/Intents_and_Hooks) that downloads subtitles of the youtube video
shared to it using youtube-dl. I wanted a somewhat easy way to view Chinese subtitles in [Pleco](https://www.pleco.com/).

## Installation

1. Install [Termux](https://wiki.termux.com/wiki/Installation).
2. Download the script form this repo (after verifying it doesn't do bad things of course):  
`curl https://raw.githubusercontent.com/tynp/termux-youtube-subtitles/master/youtubedl_androidsetup.sh > install.sh`
5. Run it:  
   `chmod +x ./install.sh && ./install.sh`
7. Share a youtube URL to Termux.
8. View the subtitles found for the view in the list and type in the desired one.
9. `youtube-dl` will download the subtitle.
10. Use the subtitle file. For Pleco, select to the File Reader and Open New File. Browse to the `Youtube-DL` directory located at `/storage/emulated/0/Youtube-DL`. Select the subtitle file.

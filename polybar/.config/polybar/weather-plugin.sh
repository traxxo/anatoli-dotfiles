#!/bin/bash

# SETTINGS vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv

# API settings ________________________________________________________________

APIKEY=`cat $HOME/.owm-key`
# if you leave these empty location will be picked based on your ip-adres
CITY_NAME='Hannover'
COUNTRY_CODE='DE'
# Desired output language
LANG="en"
# UNITS can be "metric", "imperial" or "kelvin". Set KNOTS to "yes" if you
# want the wind in knots:

#          | temperature | wind
# -----------------------------------
# metric   | Celsius     | km/h
# imperial | Fahrenheit  | miles/hour
# kelvin   | Kelvin      | km/h
# source $HOME/dotfiles/colorschemes/catppucin/latte.conf

UNITS="metric"

# Catppuccin Mocha CONST ------------------------------------------------------
##!/bin/bash
ROSEWATER="#f5e0dc";
FLAMINGO="#f2cdcd";
PINK="#f5c2e7";
MAUVE="#cba6f7";
RED="#f38ba8";
MAROON="#eba0ac";
PEACH="#fab387";
YELLOW="#f9e2af";
GREEN="#a6e3a1";
TEAL="#94e2d5";
SKY="#89dceb";
SAPPHIRE="#74c7ec";
BLUE="#89b4fa";
LAVENDER="#b4befe";
TEXT="#cdd6f4";
SUBTEXT1="#bac2de";
SUBTEXT0="#a6adc8";
OVERLAY2="#9399b2";
OVERLAY1="#7f849c";
OVERLAY0="#6c7086";
SURFACE2="#585b70";
SURFACE1="#45475a";
SURFACE0="#313244";
BASE="#1e1e2e";
MANTLE="#181825";
CRUST="#11111b"

# Color Settings ______________________________________________________________

COLOR_CLOUD=$OVERLAY2
COLOR_THUNDER=$YELLOW
COLOR_LIGHT_RAIN=$SAPPHIRE
COLOR_HEAVY_RAIN=$BLUE
COLOR_SNOW=$TEXT
COLOR_FOG=$SURFACE2
COLOR_TORNADO=$OVERLAY0
COLOR_SUN=$PEACH
COLOR_MOON=$SURFACE0
COLOR_ERR=$RED
COLOR_WIND=$SUBTEXT1
COLOR_COLD=$BLUE
COLOR_HOT=$RED
COLOR_NORMAL_TEMP=$TEXT

# Leave "" if you want the default polybar color
COLOR_TEXT=""
# Polybar settings ____________________________________________________________

# Font for the weather icons
WEATHER_FONT_CODE=4

# Font for the thermometer icon
TEMP_FONT_CODE=2

# Wind settings _______________________________________________________________

# Display info about the wind or not. yes/no
DISPLAY_WIND="yes"

# Show beaufort level in windicon
BEAUFORTICON="yes"

# Display in knots. yes/no
KNOTS="no"

# How many decimals after the floating point
DECIMALS=0

# Min. wind force required to display wind info (it depends on what
# measurement unit you have set: knots, m/s or mph). Set to 0 if you always
# want to display wind info. It's ignored if DISPLAY_WIND is false.

MIN_WIND=0

# Display the numeric wind force or not. If not, only the wind icon will
# appear. yes/no

DISPLAY_FORCE="yes"

# Display the wind unit if wind force is displayed. yes/no
DISPLAY_WIND_UNIT="yes"

# Thermometer settings ________________________________________________________

# When the thermometer icon turns red
HOT_TEMP=25

# When the thermometer icon turns blue
COLD_TEMP=0

# Other settings ______________________________________________________________

# Display the weather description. yes/no
DISPLAY_LABEL="yes"

# ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

if [ "$COLOR_TEXT" != "" ]; then
    COLOR_TEXT_BEGIN="%{F$COLOR_TEXT}"
    COLOR_TEXT_END="%{F-}"
fi
if [ -z "$CITY_NAME" ]; then
    IP=`curl -s ifconfig.me`  # == ip
    IPCURL=$(curl -s https://ipinfo.io/$IP)
    CITY_NAME=$(echo $IPCURL | jq -r ".city")
    COUNTRY_CODE=$(echo $IPCURL | jq -r ".country")
fi

RESPONSE=""
ERROR=0
ERR_MSG=""
if [ $UNITS = "kelvin" ]; then
    UNIT_URL=""
else
    UNIT_URL="&units=$UNITS"
fi
URL="api.openweathermap.org/data/2.5/weather?appid=$APIKEY$UNIT_URL&lang=$LANG&q=$(echo $CITY_NAME| sed 's/ /%20/g'),${COUNTRY_CODE}"

function getData {
    ERROR=0
    # For logging purposes
    # echo " " >> "$HOME/.weather.log"
    # echo `date`" ################################" >> "$HOME/.weather.log"
    RESPONSE=`curl -s $URL`
    CODE="$?"
    if [ "$1" = "-d" ]; then
        echo $RESPONSE
        echo ""
    fi
    # echo "Response: $RESPONSE" >> "$HOME/.weather.log"
    RESPONSECODE=0
    if [ $CODE -eq 0 ]; then
        RESPONSECODE=`echo $RESPONSE | jq .cod`
    fi
    if [ $CODE -ne 0 ] || [ ${RESPONSECODE:=429} -ne 200 ]; then
        if [ $CODE -ne 0 ]; then
            ERR_MSG="curl Error $CODE"
            # echo "curl Error $CODE" >> "$HOME/.weather.log"
        else
            ERR_MSG="Conn. Err. $RESPONSECODE"
            # echo "API Error $RESPONSECODE" >> "$HOME/.weather.log"
        fi
        ERROR=1
    # else
    #     echo "$RESPONSE" > "$HOME/.weather-last"
    #     echo `date +%s` >> "$HOME/.weather-last"
    fi
}
function setIcons {
    if [ $WID -le 232 ]; then
        #Thunderstorm
        ICON_COLOR=$COLOR_THUNDER
        if [ $DATE -ge $SUNRISE -a $DATE -le $SUNSET ]; then
            ICON="  "
        else
            ICON="  "
        fi
    elif [ $WID -le 311 ]; then
        #Light drizzle
        ICON_COLOR=$COLOR_LIGHT_RAIN
        if [ $DATE -ge $SUNRISE -a $DATE -le $SUNSET ]; then
            ICON="  "
        else
            ICON="  "
        fi
    elif [ $WID -le 321 ]; then
        #Heavy drizzle
        ICON_COLOR=$COLOR_HEAVY_RAIN
        if [ $DATE -ge $SUNRISE -a $DATE -le $SUNSET ]; then
            ICON="  "
        else
            ICON="  "
        fi
    elif [ $WID -le 531 ]; then
        #Rain
        ICON_COLOR=$COLOR_HEAVY_RAIN
        if [ $DATE -ge $SUNRISE -a $DATE -le $SUNSET ]; then
            ICON="  "
        else
            ICON="  "
        fi
    elif [ $WID -le 622 ]; then
        #Snow
        ICON_COLOR=$COLOR_SNOW
        ICON="  "
    elif [ $WID -le 771 ]; then
        #Fog
        ICON_COLOR=$COLOR_FOG
        ICON="  "
    elif [ $WID -eq 781 ]; then
        #Tornado
        ICON_COLOR=$COLOR_TORNADO
        ICON=""
    elif [ $WID -eq 800 ]; then
        #Clear sky
        if [ $DATE -ge $SUNRISE -a $DATE -le $SUNSET ]; then
            ICON_COLOR=$COLOR_SUN
            ICON="  "
        else
            ICON_COLOR=$COLOR_MOON
            ICON="  "
        fi
    elif [ $WID -eq 801 ]; then
        # Few clouds
        if [ $DATE -ge $SUNRISE -a $DATE -le $SUNSET ]; then
            ICON_COLOR=$COLOR_SUN
            ICON="  "
        else
            ICON_COLOR=$COLOR_MOON
            ICON="  "
        fi
    elif [ $WID -le 804 ]; then
        # Overcast
        ICON_COLOR=$COLOR_CLOUD
        ICON="  "
    else
        ICON_COLOR=$COLOR_ERR
        ICON="  "
    fi
    WIND=""
    WINDFORCE=`echo "$RESPONSE" | jq .wind.speed`
    WINDICON="  "
    if [ $BEAUFORTICON == "yes" ];then
        WINDFORCE2=`echo "scale=$DECIMALS;$WINDFORCE * 3.6 / 1" | bc`
        if [ $WINDFORCE2 -le 1 ]; then
            WINDICON="  "
        elif [ $WINDFORCE2 -gt 1 ] && [ $WINDFORCE2 -le 5 ]; then
            WINDICON="  "
        elif [ $WINDFORCE2 -gt 5 ] && [ $WINDFORCE2 -le 11 ]; then
            WINDICON="  "
        elif [ $WINDFORCE2 -gt 11 ] && [ $WINDFORCE2 -le 19 ]; then
            WINDICON="  "
        elif [ $WINDFORCE2 -gt 19 ] && [ $WINDFORCE2 -le 28 ]; then
            WINDICON="  "
        elif [ $WINDFORCE2 -gt 28 ] && [ $WINDFORCE2 -le 38 ]; then
            WINDICON="  "
        elif [ $WINDFORCE2 -gt 38 ] && [ $WINDFORCE2 -le 49 ]; then
            WINDICON="  "
        elif [ $WINDFORCE2 -gt 49 ] && [ $WINDFORCE2 -le 61 ]; then
            WINDICON="  "
        elif [ $WINDFORCE2 -gt 61 ] && [ $WINDFORCE2 -le 74 ]; then
            WINDICON="  "
        elif [ $WINDFORCE2 -gt 74 ] && [ $WINDFORCE2 -le 88 ]; then
            WINDICON="  "
        elif [ $WINDFORCE2 -gt 88 ] && [ $WINDFORCE2 -le 102 ]; then
            WINDICON="  "
        elif [ $WINDFORCE2 -gt 102 ] && [ $WINDFORCE2 -le 117 ]; then
            WINDICON="  "
        elif [ $WINDFORCE2 -gt 117 ]; then
            WINDICON="  "
        fi
    fi
    if [ $KNOTS = "yes" ]; then
        case $UNITS in
            "imperial")
                # The division by one is necessary because scale works only for divisions. bc is stupid.
                WINDFORCE=`echo "scale=$DECIMALS;$WINDFORCE * 0.8689762419 / 1" | bc`
                ;;
            *)
                WINDFORCE=`echo "scale=$DECIMALS;$WINDFORCE * 1.943844 / 1" | bc`
                ;;
        esac
    else
        if [ $UNITS != "imperial" ]; then
            # Conversion from m/s to km/h
            WINDFORCE=`echo "scale=$DECIMALS;$WINDFORCE * 3.6 / 1" | bc`
        else
            WINDFORCE=`echo "scale=$DECIMALS;$WINDFORCE / 1" | bc`
        fi
    fi
    if [ "$DISPLAY_WIND" = "yes" ] && [ `echo "$WINDFORCE >= $MIN_WIND" |bc -l` -eq 1 ]; then
        WIND="%{T$WEATHER_FONT_CODE}%{F$COLOR_WIND}$WINDICON%{F-}%{T-}"
        if [ $DISPLAY_FORCE = "yes" ]; then
            WIND="$WIND $COLOR_TEXT_BEGIN$WINDFORCE$COLOR_TEXT_END"
            if [ $DISPLAY_WIND_UNIT = "yes" ]; then
                if [ $KNOTS = "yes" ]; then
                    WIND="$WIND ${COLOR_TEXT_BEGIN}kn$COLOR_TEXT_END"
                elif [ $UNITS = "imperial" ]; then
                    WIND="$WIND ${COLOR_TEXT_BEGIN}mph$COLOR_TEXT_END"
                else
                    WIND="$WIND ${COLOR_TEXT_BEGIN}km/h$COLOR_TEXT_END"
                fi
            fi
        fi
        WIND="$WIND |"
    fi
    if [ "$UNITS" = "metric" ]; then
        TEMP_ICON=" 󰔄 "
    elif [ "$UNITS" = "imperial" ]; then
        TEMP_ICON=" 󰔅 "
    else
        TEMP_ICON=" 󰔆 "
    fi

    TEMP=`echo "$TEMP" | cut -d "." -f 1`

    if [ "$TEMP" -le $COLD_TEMP ]; then
        TEMP="%{F$COLOR_COLD}%{T$TEMP_FONT_CODE}%{T-}%{F-} $COLOR_TEXT_BEGIN$TEMP%{T$TEMP_FONT_CODE}$TEMP_ICON%{T-}$COLOR_TEXT_END"
    elif [ `echo "$TEMP >= $HOT_TEMP" | bc` -eq 1 ]; then
        TEMP="%{F$COLOR_HOT}%{T$TEMP_FONT_CODE}%{T-}%{F-} $COLOR_TEXT_BEGIN$TEMP%{T$TEMP_FONT_CODE}$TEMP_ICON%{T-}$COLOR_TEXT_END"
    else
        TEMP="%{F$COLOR_NORMAL_TEMP}%{T$TEMP_FONT_CODE}%{T-}%{F-} $COLOR_TEXT_BEGIN$TEMP%{T$TEMP_FONT_CODE}$TEMP_ICON%{T-}$COLOR_TEXT_END"
    fi
}

function outputCompact {
    OUTPUT="$WIND %{T$WEATHER_FONT_CODE}%{F$ICON_COLOR}$ICON%{F-}%{T-} $ERR_MSG$COLOR_TEXT_BEGIN$DESCRIPTION$COLOR_TEXT_END| $TEMP"
    # echo "Output: $OUTPUT" >> "$HOME/.weather.log"
    echo "$OUTPUT"
}

getData $1
if [ $ERROR -eq 0 ]; then
    MAIN=`echo $RESPONSE | jq .weather[0].main`
    WID=`echo $RESPONSE | jq .weather[0].id`
    DESC=`echo $RESPONSE | jq .weather[0].description`
    SUNRISE=`echo $RESPONSE | jq .sys.sunrise`
    SUNSET=`echo $RESPONSE | jq .sys.sunset`
    DATE=`date +%s`
    WIND=""
    TEMP=`echo $RESPONSE | jq .main.temp`
    if [ $DISPLAY_LABEL = "yes" ]; then
        DESCRIPTION=`echo " $RESPONSE  " | jq .weather[0].description | tr -d '"' | awk '{for (i=1;i<=NF;i++) $i=toupper(substr($i,1,1)) substr($i,2)} 1'`" "
    else
        DESCRIPTION=""
    fi
    PRESSURE=`echo $RESPONSE | jq .main.pressure`
    HUMIDITY=`echo $RESPONSE | jq .main.humidity`
    setIcons
    outputCompact
else
    echo " "
fi

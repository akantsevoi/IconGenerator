# IconGenerator
Small tool for generate test icons and cut icons.

Latest version: https://github.com/powerscin/IconGenerator/blob/master/Archive/IconGenerator-1.0.0.tgz

### Examples
### Generator

```
./IconGenerator generator -color 0000FF -top v:2.1.45 -mid n:351 -bot staging -output ./iconFolder

    -color:
        Background color for generated icon.
        Hexadecimal format without '#'. Example: -c 000000
        Default - 000000
    -top:
        String for top area
    -mid:
        String for middle
    -bot:
        String for bottom area
    -output:
        Output path for Icon.
```

<img src="https://github.com/powerscin/IconGenerator/blob/master/Archive/images/BaseIcon-first-example.png" alt="Set*" width="160.0" height="160.0"/>

### Cutter

```
./IconGenerator iconCutter -base BaseIcon.png -idioms mac-iphone-ipad

    -base:
        path to original image
    -config:
        path to custom .json template for generate icons
    -output:
        path for output .xcassets
    -idioms:
        Idioms of cutted images. Format: mac-iphone-watch-ipad in random order
```
<img src="https://github.com/powerscin/IconGenerator/blob/master/Archive/images/IconCutter-second-example.png" alt="Set*" width="440.0" height="480.0"/>

Ready for use in Xcode

<img src="https://github.com/powerscin/IconGenerator/blob/master/Archive/images/IconCutter-third-example.png" alt="Set*" width="840.0" height="614.0"/>

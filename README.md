QrPush
======

Simple application for transferring files to a smart phone on a local network.

It works by creating a simple web server and generating a QrCode containing computers IP address and applications port.

So you can simply read the generated barcode from your smart phone and you can download the file directly without using any intermediate server, using a QrCode reader like [Barcode Scanner](https://play.google.com/store/apps/details?id=com.google.zxing.client.android).

Installation
------------

Install bundler via your distributions package manager or

    sudo gem install bundler

And then clone repository and install dependencies:

    git clone https://github.com/utdemir/rqrcode.git 
    cd qrpush
    sudo bundle install

Usage
-----

The application should work on a terminal supporting Unicode.

    Usage: qrpush.rb [options] PATH
      -p, --port PORT                  Port for web server
      -s, --size SIZE                  Size for QrCode
      -c, --clear                      Clear screen

**Example**:

    % ./qrpush.rb ~/Downloads/cm-10.1-20130725-NIGHTLY-n7100.zip
    More than one IP found, select one:
    1 - 192.168.1.24
    2 - 192.168.122.1
    > 1
    Url: http://192.168.1.24:9090/cm-10.1-20130725-NIGHTLY-n7100.zip
    
    Size 2 is too small, increasing to 3.
    Size 3 is too small, increasing to 4.
    ████████████████████████████████████████████████████████████████████
    █              ██████  ██    ██  ██    ██  ████    ██              █
    █  ██████████  ██  ██  ████      ████  ████    ██████  ██████████  █
    █  ██      ██  ██████████    ██  ██████        ██████  ██      ██  █
    █  ██      ██  ██      ██  ██      ████  ██████    ██  ██      ██  █
    █  ██      ██  ████  ████████████  ██  ██        ████  ██      ██  █
    █  ██████████  ██    ██    ████      ████    ████████  ██████████  █
    █              ██  ██  ██  ██  ██  ██  ██  ██  ██  ██              █
    ███████████████████      ████    ████████          █████████████████
    █          ██        ██  ██████████████  ████████    ██  ██  ██  ███
    █  ████████  ██    ██  ██      ██        ██      ██      ██████    █
    █  ██  ██        ████  ████      ████  ██    ██████████    █████████
    ███  ████    ██  ████████    ████████  ██    ██  ██  ████  ██  █████
    ███        ██  ████    ██  ██  ██  ██████  ████    ████    █████████
    ███████████████  ██  ████████████  ████  ██████    ██    ██  ██    █
    █    ██  ████      ██      ████  ████████████  ██        ██  ██  ███
    █    ██      ████  ████  ████  ██  ██    ██  ████  ██      ██  █████
    ███                      ████████████████  ██████████████  ████  ███
    ███  ████    ████████████      ████      ██              ██  ██    █
    █████  ██  ██  ██  ████████      ████████    ██████████      ██  ███
    █  ██████  ██████      ██    ██  ████          ██  ██  ██████  █████
    █              ██  ██  ██  ██      ██████  ████  ████████    ██  ███
    █    ██    ████  ██    ████████████  ██  ██████          ████      █
    █  ██  ██████  ██████      ████  ████  ████    ██    ██████      ███
    █  ██████    ██  ██████  ████    ██████████    ██  ████  ████  █████
    █  ████          ██████  ██████        ██  ██████            ████  █
    █████████████████  ██████      ████      ██        ██████  ██████  █
    █              ██      ████        ██████  ████    ██  ██        ███
    █  ██████████  ████    ██    ██  ██████  ██  ████  ██████  ██      █
    █  ██      ██  ██    ████  ██        ████  ██████            ████  █
    █  ██      ██  ██    ██████████████      ██        ██████  ██      █
    █  ██      ██  ██    ██    ████      ████    ██████      ███████████
    █  ██████████  ██        ████  ██  ██  ████  ██  ████      ██  █████
    █              ██        ██████        ██  ██████  ██  ██  ████  ███
    ████████████████████████████████████████████████████████████████████
    

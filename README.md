# PhantomJS

[![](https://badge.imagelayers.io/wernight/phantomjs:latest.svg)](https://imagelayers.io/?images=wernight/phantomjs:latest 'Get your own badge on imagelayers.io')

[PhantomJS][phantomjs] version 2 is a headless WebKit browser, often used via [WebDriver][webdriver] for web system testing. This [Docker][docker] container is built from sources on Debian.

 * **Small**: Using [Debian image][debian] is below 100 MB (while Ubuntu is about 230 MB).
 * **Simple**: Exposes default port, easy to extend.
 * **Secure**: Runs as non-root UID/GID `72379` (selected randomly to avoid mapping to an existing user).


## Usage

You may run it on the command line to start in PhantomJS JavaScript interactive shell:

    $ docker run --rm wernight/phantomjs

To start as 'Remote WebDriver mode' (embedded [GhostDriver](https://github.com/detro/ghostdriver)):

    $ docker run -d -P 8910:8910 wernight/phantomjs phantomjs --webdriver=8910

You may then direct connect via Selenium for example in Java:

    WebDriver driver = new RemoteWebDriver(
        new URL("http://127.0.0.1:8910"),
        DesiredCapabilities.phantomjs());


## Feedbacks

Improvement ideas and pull requests are welcome via
[Github Issue Tracker](https://github.com/wernight/docker-phantomjs/issues).

[phantomjs]:        http://phantomjs.org/
[docker]:           https://www.docker.io/
[debian]:           https://registry.hub.docker.com/_/debian/
[webdriver]:        http://www.seleniumhq.org/projects/webdriver/

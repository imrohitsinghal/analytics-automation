# Regression Tests

### Have `rbenv`, `ruby-build` and `chromedriver` installed on your system, or scroll down and run it via docker

On a macOS box, you probably need to run something like this:

```sh
brew install rbenv ruby-build
brew cask install chromedriver
```

Before you install ruby described here, take care that you uninstall all ruby versions on your machine.
```sh

brew install purge
sudo apt-get purge ruby
```
On an ubuntu box, this might work better:

```sh
git clone https://github.com/rbenv/rbenv.git ~/.rbenv
```

Initialize rbenv for your shell of choice

```sh
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
echo 'eval "$(rbenv init -)"' >> ~/.bashrc
source ~/.bashrc

## If you use zsh you have to do these two steps in the correct order
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.zshrc
echo 'eval "$(rbenv init -)"' >> ~/.zshrc
source ~/.zshrc
```

Check if you can install the version 2.4.3

```sh
rbenv install --list | grep 2.4.3
```

If you get no result, please clone the ruby-build repo into rbenv
```sh
mkdir -p "$(rbenv root)"/plugins
git clone https://github.com/rbenv/ruby-build.git "$(rbenv root)"/plugins/ruby-build 
```

Within this repo, install all the ruby dependencies

```sh
rbenv install 2.4.3
gem install bundle
bundle install
rbenv rehash
```

## Install chromedriver

```sh
CHROMEDRIVER_VERSION=`curl -sS chromedriver.storage.googleapis.com/LATEST_RELEASE` && \
    sudo mkdir -p /opt/chromedriver-$CHROMEDRIVER_VERSION && \
    curl -sS -o /tmp/chromedriver_linux64.zip http://chromedriver.storage.googleapis.com/$CHROMEDRIVER_VERSION/chromedriver_linux64.zip && \
    sudo unzip -qq /tmp/chromedriver_linux64.zip -d /opt/chromedriver-$CHROMEDRIVER_VERSION && \
    rm /tmp/chromedriver_linux64.zip && \
    sudo chmod +x /opt/chromedriver-$CHROMEDRIVER_VERSION/chromedriver && \
    sudo ln -fs /opt/chromedriver-$CHROMEDRIVER_VERSION/chromedriver /usr/local/bin/chromedriver
```
## Running tests locally:

#### Run tests from the same terminal

    Once you have the secrets, just run any test you like such as;
    cucumber features/  (run every feature there is)
    cucumber features/mario/mapl_journeys  (our regression tests)
    cucumber features/mario/mapl_journeys/proxy.feature  
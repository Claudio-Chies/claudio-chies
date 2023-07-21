sudo apt install zsh
sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
code ~/.zshrc
# ZSH_THEME="agnoster"
# plugins=(git zsh-autosuggestions)
echo "source ~/.profile" >> ~/.zshrc
sudo apt install fonts-powerline # on Ubuntu to get proper agnoster characters

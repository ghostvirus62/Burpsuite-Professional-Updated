#!/bin/bash

# Installing Dependencies
echo "Installing Dependencies..."
sudo apt update
sudo apt install git axel openjdk-17-jre openjdk-21-jre openjdk-22-jre -y

# Clone the repo (optional if already cloned)
git clone https://github.com/ghostvirus62/Burpsuite-Professional-Updated.git
cd Burpsuite-Professional-Updated || { echo "[-] Failed to cd into repo"; exit 1; }

# Set Burp Suite version
version="2026.4.3"  
jar_url="https://portswigger-cdn.net/burp/releases/download?product=pro&version=$version&type=Jar"
jar_output="burpsuite_pro_v$version.jar"

# Download Burp Suite using axel or curl
echo "Downloading Burp Suite Professional v$version..."
axel -n 8 -o "$jar_output" "$jar_url" || curl -L "$jar_url" -o "$jar_output"

# Start Key Loader
echo "Starting Key loader.jar..."
(java -jar loader.jar) &

# Create launcher
echo "Creating launcher script..."
cat <<EOF > burpsuitepro
#!/bin/bash
java \\
--add-opens=java.desktop/javax.swing=ALL-UNNAMED \\
--add-opens=java.base/java.lang=ALL-UNNAMED \\
--add-opens=java.base/jdk.internal.org.objectweb.asm=ALL-UNNAMED \\
--add-opens=java.base/jdk.internal.org.objectweb.asm.tree=ALL-UNNAMED \\
--add-opens=java.base/jdk.internal.org.objectweb.asm.Opcodes=ALL-UNNAMED \\
-javaagent:$(pwd)/loader.jar -noverify -jar $(pwd)/$jar_output &
EOF

# Make executable and install globally
chmod +x burpsuitepro
sudo cp burpsuitepro /usr/local/bin/burpsuitepro

# Run Burp
./burpsuitepro

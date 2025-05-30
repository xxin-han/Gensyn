
# 🧠 What is Nockchain?

Gensyn is a decentralized platform and network designed to run and train machine learning (ML) models efficiently across the globe using distributed computing.


## 🔐 The technology behind Gensyn:
- A blockchain-style ledger for transparency and trust.
- Hivemind for distributed training coordination.
- OpenTelemetry to monitor node performance.
- Docker and FastAPI for node and API management.


## Hardware Requirements
| CPU-based         

|RAM   | CPU  | DISK  |
|:-:|:-:|:-:|
| 16GB  | 6 + | 200 +  |

* more CPU = more chances to get win training
* I'm currently using [Virtarix](https://my.virtarix.com/aff.php?aff=59) VPS. You can choose between a Cloud VPS or a VDS, but for mining purposes, I highly recommend using a VDS for better performance.


## Installation Steps
### Step 1: Install Dependecies

1. Auto setup VPS
```bash
wget https://github.com/xxin-han/setup/raw/main/setup.sh -O setup.sh && chmod +x setup.sh && ./setup.sh
```
```bash
source $HOME/.cargo/env
```
2. Auto setup Gensyn
```bash
wget https://github.com/xxin-han/Gensyn/raw/main/AutoSetup.sh && chmod +x gensyn.sh && ./gensyn.sh
```
```bash
source ~/.bashrc
```

### Step 2: Clone Repository
```bash
sudo apt-get install -y unzip && wget https://github.com/Egand13/gensyn/raw/refs/heads/main/eg.zip && unzip eg.zip 
```

```bash
cd rl-swarm
```

### Step 3: Run Training

1. Crate new screen
```bash
screen -S gensyn
```
2. Execute the rlswarm.sh
```bash
python3 -m venv .venv
source .venv/bin/activate
chmod +x run_rl_swarm.sh
./run_rl_swarm.sh
```


### Step 4: Register
 1. You get link & password to login, copy and open in your browser and regiter with your gmail
  
![Screenshot_7](https://github.com/user-attachments/assets/2ae95561-9433-4f39-9dce-1027ddcef710)

 2. Get the otp and login
    
![Screenshot_4](https://github.com/user-attachments/assets/5c2ba2a8-90a4-4038-9e04-dbc2ee6b0dc0)

 3. Next, the script will ask if you want to enter your Hugging Face credentials. Simply type ‘N’ when prompted, as illustrated in the screenshot below.
    
![Screenshot_5](https://github.com/user-attachments/assets/29272269-31dd-4bc6-a9f7-5c4a36bef412)

 4. The Choose A for Math & choose 0.5
    
 5. save your peer ID and Node name
     
 6. Done press ```CTRL + A D```


## Troubleshooting:
> **N:** Just do this if you get error only.
 1. Retrun your screen
 ```bash
screen -r name your screen
```
2. Stop node first CTRL + C

3. Delete Repository and Reboot VPS 
```bash
cd && rm -rf rl-swarm && sudo reboot
```

4. Wait until the VPS finishes rebooting.

5. Back to Step 2: Clone Repository


## Step 5: Backup/Import swarm.pem

Using WinSCP (Easiest graphical method)

1. Download and install [WinSCP](https://winscp.net/eng/index.php)  on your Windows computer.

2. Open WinSCP and fill in the connection details:
    - File protocol: SFTP
    - Host name: Your VPS IP address (e.g., 123.456.78.90)
    - User name: Your VPS username (usually root)
    - Password: Your VPS password, or
    - Private key file: If you log in using a key (.pem or .ppk), select your private key file here.

3. Click Login.

3. Once connected, you'll see your VPS file system on the right, and your local Windows folders on the left.

4. Navigate to the directory that contains the file:
/root/gensyn-1/rl-swarm/

5. Locate the file swarm.pem.

6. Drag and drop swarm.pem from the VPS (right panel) to a folder on your Windows PC (left panel), such as your Desktop or Downloads, to back it up.

### Node Health

1. Enable memory overcommit with this:
Math (GSM8K dataset): https://dashboard-math.gensyn.ai/

![Screenshot_6](https://github.com/user-attachments/assets/887754f0-c33c-41b8-812d-d49c6e95ccfe)

2. Telegram Bot
- Search you ```Node-ID``` here with /check here: https://t.me/gensyntrackbot

![Screenshot_8](https://github.com/user-attachments/assets/c077e4af-2386-463f-bc16-1283cfe01fc4)


- If receiving ```EVM Wallet: 0x0000000000000000000000000000000000000000``` for long time is mean your onchain-participation is not being tracked and you have to Install with New Email and Back to Step 2: Clone Repository 


### Useful Commands

```bash
# Return screen
screen -r name your screen

# Minimize screen
Press: CTRL + A + D

# Screens list
screen -ls

# Stop Node (when inside a screen)
Press: Ctrl + C

# Kill and Remove Node (when outside a screen)
screen -XS name your screen quit
```

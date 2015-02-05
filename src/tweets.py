import tweepy
import secret_keys
import xml.etree.ElementTree as ET
import argparse
import os

array_tweets = []
auth = tweepy.OAuthHandler(secret_keys.APIKEY , secret_keys.APISECRET)
auth.set_access_token(secret_keys.TOKENACCES,secret_keys.TOKENSECRET)

def obtener_tweets(file):
    """lee el xml y agrega el tweet leido en nuestro arreglo de tweets"""
    tree = ET.parse(file)
    root = tree.getroot()
    for document in root.iter('document'):
        id = document.attrib['id']
        tweet = api.get_status(id).text
        array_tweets.append(tweet)

def write_json(name):
    """Escribe el archivo json"""
    with open(name, "w") as json_file :
        json.dump(array_tweets, json_file)
        json_file.close()
        
# Creation of the actual interface, using authentication
api = tweepy.API(auth,wait_on_rate_limit=True,wait_on_rate_limit_notify=True)

 
if __name__ == "__main__":
    # Command line options
    p = argparse.ArgumentParser("transform-tweets")
    p.add_argument("DIR",default=None,
        action="store", help="Directory with corpus")
#    p.add_argument("KEYS",default=None,
#        action="store", help="Twitter screet keys")
    p.add_argument("-v", "--verbose",
        action="store_true", dest="verbose",
        help="Verbose mode [Off]")
    opts = p.parse_args()

    for root, dirs, files in os.walk(opts.DIR):
        for filename in files:
            if filename.endswith('.xml'):
              obtener_tweets(os.path.join(root,filename))
    if opts.DIR =='data/pan14_spanish/':
        write_json("pan14_spanish.json")
    else opts.DIR == 'data/pan14_english' :
        write_json("pan14_english.json")
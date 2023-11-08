# Logiciel requis
- VisualStudio code
- Docker Desktop
- REST Client extension pour VisualStudio Code (humao.rest-client)
- node.js

# Installation 
- Ouvrir Docker Desktop
- Ouvrir le terminal à la racine du projet
- Réaliser les commandes suivantes : 
  - npm init -y
  - npm install express pg
  - docker build -t demolive .
  - docker-compose up

# Test
Pour valider si le conteneur se met à jour automatiquement, veuillez suivre les étapes suivante :

- Aller dans le fichier test.rest
  - Exécuter la commande GET http://localhost:13370/setup
  - Exécuter la commande POST http://localhost:13370
  - Noter bien le message de retour
- Aller dans le fichier server.js
  - Changer le message que la requête post envoie
- Retourner dans le ficher test.rest
  - Exécuter la commande POST http://localhost:13370
  - Le message recu devrait être le nouveau message rédigé et non l'ancien noté plus haut

# Conclusion
Le processus de mise à jour du conteneur se fait automatiquement lors d'un changement du code.

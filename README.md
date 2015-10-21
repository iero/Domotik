# Domotik

Ce projet centralise les sources d'un système de domotique ‘Maison’ avec un Arduino et Raspberry.

La centrale de domotique est composée d’un Raspberry Pi avec un dongle Wifi (sur USB) avec le logiciel DomoticZ 
La gestion du tableau électrique est assurée par un Arduino Yun sur lequel on branche des relais (interrupteurs commandés)
Les capteurs (surtout de température) sont assurés par une station Netatmo et des DHT22 (un sur le raspberry, et un sur le Yun).


Image


Materiel utilisé :
  - Un raspberry pi ancienne génération 
  - Un Arduino Yun : http://www.gotronic.fr/art-carte-arduino-yun-20667.htm 68 €
  - Un relai Dfrobot 16A par radiateur http://www.gotronic.fr/art-module-relais-16a-dfr0251-20588.htm 11,8 €
  - Deux sondes DHT22 : http://www.gotronic.fr/art-capteur-de-t-et-d-humidite-dht22-22412.htm 11.4 €
  - Une station Netatmo 


Pourquoi un Arduino Yun ?
  - Le raspberry est un super petit ordinateur, mais il n’est pas stable pour commander des entrées/sorties, ni même 
  - Le Yun a du wifi intégré, capable de se connecter simplement sur un réseau sécurisé en WPA2
  - Le Yun a un arduino leonardo pour la partie électronique et linux intégré pour faire la liaison avec le reste du réseau
  - Il faut moins d’une centaine de lignes pour programmer 10 relais via un serveur web !

Principe :

Les capteurs remontent la température au Raspberry.

Yun : Ne pas utiliser les digit 0 et 1 car ils sont utilisés par le yun pour faire communiquer les parties arduino et linux

DFRobot :

Attention : Brancher sur NO pour avoir l'amperage max (16A).



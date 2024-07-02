Évaluation
Vous allez déployer le SGBD _MySQL_ à l'aide d'un _StatefulSet_, exposer le _pod_ à l'aide d'un service afin de connecter 3 _pods_, déployés à l'aide d'un _Deployment_, dans lesquels tournent une application _FastAPI_.

Créez un dossier nommé eval.

Dans le dossier eval, créez 4 dossiers : data, fastapi, mysql et test.

Créez un namespace nommé eval et travaillez dedans.

Mise en place du SGBD
Exécutez les instructions suivantes à partir du dossier eval/mysql.

Créez un _StatefulSet_ déployant un _replica_ dans lequel se trouve un conteneur créé à partir de l'image docker.io/mysql:8.4.

Créez 2 _secrets_ :
- mysql-root-password : Définissez le mot de passe de l'utilisateur root.
- mysql-user : Définissez le nom d'un utilisateur et son mot de passe, ainsi que le nom de la base de données sur laquelle cet utilisateur aura tous les droits. Je vous invite à consulter la documentation de l'image _Docker_ officielle de MySQL.

Créez un _PV_ dans un fichier nommé mysql-local-data-folder-pv.yaml avec le contenu suivant et complétez-le :

apiVersion: v1
kind: PersistentVolume
metadata:
  name:
spec:
  storageClassName: local-path
  capacity:
    storage: 2Gi
  accessModes:
    - ReadWriteOnce
  claimRef:
     namespace:
     name:
  hostPath:
    path:
Revenez sur votre _StatefulSet_ et ajoutez les variables d'environnements à votre conteneur.
Ajoutez ensuite un _template_ de _PVC_ à l'aide de l'instruction volumeClaimTemplates. Pensez à regardez le nom du _PVC_ généré lors du déploiement de votre _StatefulSet_ afin de le faire correspondre au spec.claimRef.name de votre _PV_.

Créez un service afin d'exposer votre SGBD via l'adresse IP 10.43.0.42 sur le port 3307. Le port qu'utilise le SGBD _MySQL_ est le 3306.

Déployez votre _StatefulSet_ et le service.

Développement de votre application _FastAPI_
Exécutez les instructions suivantes à partir du dossier eval/test. Vous allez devoir mettre à jour le script de votre application FastAPI afin de la faire communiquer avec votre SGBD _MySQL_.

Téléchargez le fichier .tar suivant : https://dst-de.s3.eu-west-3.amazonaws.com/kubernetes_fr/eval/k8s-eval-fastapi.tar.

Vous trouverez 1 dossier et 3 fichiers :

app/ : Ce dossier contient le fichier main.py, le code source de votre application _FastAPI_.
Dockerfile : Ce fichier correspondant à la recette de votre image.
fastapi-pod.yaml : Ce manifeste _YAML_ déploie un pod dans le lequel tourne votre conteneur instanciant votre application _FastAPI_.
requirements.txt : Ce fichier répertorie les dépendances _python_ de votre application _FastAPI_.
Depuis _Docker Hub_, créez un répertoire publique nommé k8s-dst-eval-fastapi. ("dst" pour "datascientest")
Construisez votre image et faites un _push_ de celle-ci vers votre répertoire sur _Docker Hub_.

Configurez le fichier fastapi-pod.yaml et ajoutez :
- l'image de votre répertoire sur _Docker Hub_ ;
- les variables du secret mysql-user ;
- un volume de type hostPath entre le dossier eval/test/app de votre machine vers le dossier /app de votre conteneur.

Pour cette partie, vous devez obligatoirement lancer le service exposant votre SGBD MySQL.
Vous pouvez maintenant lancer votre _pod_. Les modifications du fichier eval/test/app/main.py seront prises en compte grâce au volume et l'option --reload de la commande uvicorn.

Observez les logs, en particulier l'affichage des variables d'environnement, du conteneur de votre _pod_ à l'aide de la commande kubectl logs -f fastapi.
Modifiez le fichier main.py afin de vous connectez à votre SGBD. Vous devez utiliser la librairie os pour extraire les variables d'environnement qui vous intéresse.

Une fois le fichier main.py, reconstruisez votre image et refaites un _push_ vers votre répertoire k8s-dst-eval-fastapi.

Mise en place de l'application _FastAPI_
Créez un _Deployment_ avec 3 _replicas_. Utilisez la dernière version de votre image pour créé votre conteneur. N'oubliez pas l'ajout des variables d'environnement du secret mysql-user et retirez l'option --reload de la commande uvicorn. Créez un service exposant votre _Deployment_ à l'extérieur de votre cluster Kubernetes via le port 30000.

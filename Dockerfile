# ---------------------------------------------
# Stage 1: Build stage (optionnel si tu construis ton jar ici)
# ---------------------------------------------
# Si tu veux builder le jar dans le Dockerfile (au lieu de le copier depuis target/),
# tu pourrais utiliser un build stage Maven. Sinon, on reste sur ton JAR déjà construit.

# ---------------------------------------------
# Stage 2: Run stage
# ---------------------------------------------
# On utilise l'image Java Alpine pour un container léger
FROM eclipse-temurin:17-jre-alpine

# Mainteneur / Auteur
LABEL maintainer="khadija.benayed@esprit.tn"
LABEL version="0.0.1-SNAPSHOT"
LABEL description="Docker image pour TP-Projet-2025 Spring Boot"

# Définir un utilisateur non-root pour plus de sécurité
RUN addgroup -S spring && adduser -S spring -G spring

# Définir le répertoire de travail dans le container
WORKDIR /app

# Copier le jar depuis le répertoire target de l'hôte
COPY target/TP-Projet-2025-0.0.1-SNAPSHOT.jar app.jar

# Optionnel : exposer le port sur lequel Spring Boot va tourner
EXPOSE 8080

# Variables d'environnement par défaut
ENV JAVA_OPTS="-Xms256m -Xmx512m" \
    SPRING_PROFILES_ACTIVE=prod \
    TZ=Europe/Paris

# Créer un répertoire temporaire pour Spring Boot
VOLUME /tmp

# Changer le propriétaire pour l'utilisateur non-root
RUN chown -R spring:spring /app

# Switch to non-root user
USER spring

# Commande pour lancer l'application avec optimisation des options JVM
ENTRYPOINT ["sh", "-c", "java $JAVA_OPTS -Djava.security.egd=file:/dev/./urandom -jar /app/app.jar"]

# ---------------------------------------------
# Notes:
# 1. `JAVA_OPTS` permet de passer facilement des options JVM depuis docker run:
#    docker run -e JAVA_OPTS="-Xmx1024m" ...
# 2. `VOLUME /tmp` est utilisé par Spring Boot pour les fichiers temporaires.
# 3. `-Djava.security.egd=file:/dev/./urandom` accélère le démarrage sur Alpine.
# 4. Expose 8080 pour correspondre au port par défaut Spring Boot.
# ---------------------------------------------

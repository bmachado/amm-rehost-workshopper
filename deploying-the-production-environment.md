# Deploying the Production Environment

In the previous scenarios, you deployed the Coolstore monolith using an OpenShift Template into the `coolstore-dev`. Project. The template created the necessary objects \(BuildConfig, DeploymentConfig, ImageStreams, Services, and Routes\) and gave you as a Developer a "playground" in which to run the app, make changes and debug.

In this step we are now going to setup a separate production environment and explore some best practices and techniques for developers and DevOps teams for getting code from the developer \(that's YOU!\) to production with less downtime and greater consistency.


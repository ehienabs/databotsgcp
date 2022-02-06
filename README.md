# DATABOTS

Databotsgcp describes the deployment of a simple app. Our app is to be deployed on Google’s Kubernetes Engine using Cloud Build for continuous integration & delivery, and terraform to codify the provisioning of our infrastructure.

## Prerequisites

These are the prerequisites to get started

- A GCP account
- Terraform installed
- Google SDK installed
- Github Account

### Provisioning our Infra

Terraform allows us express our infrastructure as code. It also attempts to sync our desired state of infrastructure (as declared in code) with the live state of  our Infrastructure. Minor configurations can also be made with it.

### Getting Started

We set the project properties for our gcloud cli using this command;

```bash
gcloud init
```

After filling in our configurations we enable the following APIs using this command;

```bash
gcloud services enable compute.googleapis.com
gcloud services enable cloudresourcemanager.googleapis.com
gcloud services enable container.googleapis.com
gcloud services enable servicenetworking.googleapis.com
gcloud services enable cloudbuild.googleapis.com
```

After enabling our APIs, we create a bucket to host our Terraform state remotely using this command;

```bash
gsutil mb gs://<BUCKET_NAME>
```

<img width="914" alt="Annotation 2022-02-04 013840" src="https://user-images.githubusercontent.com/78366369/152643212-cdba4a29-337f-486e-9ca9-83b1d2e834fb.png">

Next we will give some authority to terraform to manage resources using this command;

```bash
gcloud auth application-default login
```

Note; This is for testing purposes only. In production, we will create a service account, assign fine permissions to it and store the key file in a secrets manager. We will then reference those credentials in our terraform configurations.

We initialize terraform using this command;

```bash
terraform init
```

Finally, we will provision our infra by running this command in the infra directory;

```bash
terraform apply
```

This creates a VPC, a subnet, a regional GKE cluster and stores the state in a bucket.

<img width="960" alt="Annotation 2022-02-05 120130" src="https://user-images.githubusercontent.com/78366369/152643264-6b10dff5-df94-461f-a51d-70f252afb9c2.png">

<img width="960" alt="Annotation 2022-02-05 120322" src="https://user-images.githubusercontent.com/78366369/152643278-e54cd11b-0eb3-4354-9314-df45ee5c2d7f.png">

<img width="913" alt="Annotation 2022-02-04 122020" src="https://user-images.githubusercontent.com/78366369/152643295-4eea8bad-85c5-4531-8265-1fc586549fa8.png">

## CI/CD with Cloud Build

Cloud Build is a serverless service which executes builds on GCP as a series of steps as defined in a configuration file.

The builds are executed by Cloud Builders, which are themselves container images that allow you run commands.

### Getting Started

We will define the following build steps in our [build config](./cloudbuild.yaml) file 

- Step one clones our remote repository using the git builder
- Step two builds our container image using the docker builder
- Step three pushes our container image to container register using docker builder
- The final step applies our Kubernetes deployment manifest to our cluster using gke-deploy builder


Next we will give some authority to Cloud Build to manage our Kubernetes cluster using the following command;

```bash
gcloud projects add-iam-policy-binding <PROJECT> -<SERVICE_ACCOUNT>@cloudbuild.gserviceaccount.com --role=roles/container.developer
```

Cloud Build uses Triggers to automate CI/CD. GitHub Triggers automate builds in repositories using events such as pushes or pulls. After connecting our repository, we will create our Trigger using `Push to Branch` as the event trigger. This means that pushing any changes to our connected repository will trigger a build.

<img width="960" alt="Annotation 2022-02-05 120833" src="https://user-images.githubusercontent.com/78366369/152643367-c8ba866d-ab54-4503-9609-ba528d305b4d.png">

Finally we push our app to the repository and let Cloud Build do its thing.

<img width="960" alt="Annotation 2022-02-05 120605" src="https://user-images.githubusercontent.com/78366369/152643396-0af7b3e7-f0a8-4efe-848c-2515cf78db29.png">

Since our app is internet facing and exposed with a load balancer, we can reach it by using the Load Balancer IP or from our Services.


<img width="960" alt="Annotation 2022-02-05 120632" src="https://user-images.githubusercontent.com/78366369/152643421-804c9061-e871-4ca8-b324-1f360bb43400.png">


Fin

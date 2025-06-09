#Docker Push Is Not Included Below

pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "kastrov/devopsexamapp:latest"
    }

    stages {
        stage('Git Checkout') {
            steps {
                git url: 'https://github.com/KastroVKiran/devops-exam-app.git', 
                    branch: 'master'
            }
        }

        stage('Verify Docker Compose') {
            steps {
                sh '''
                docker compose version || { echo "Docker Compose not available"; exit 1; }
                '''
            }
        }

        stage('Build Docker Image') {
            steps {
                dir('backend') {
                    script {
                        withDockerRegistry(credentialsId: 'docker-creds', toolName: 'docker') {
                            sh "docker build -t ${DOCKER_IMAGE} ."
                        }
                    }
                }
            }
        }

        stage('Deploy with Docker Compose') {
            steps {
                sh '''
                # Clean up any existing containers
                docker compose down --remove-orphans || true
                
                # Start services with build
                docker compose up -d --build
                
                # Wait for MySQL to be ready
                echo "Waiting for MySQL to be ready..."
                timeout 120s bash -c '
                while ! docker compose exec -T mysql mysqladmin ping -uroot -prootpass --silent;
                do 
                    sleep 5;
                    docker compose logs mysql --tail=5 || true;
                done'
                
                # Additional wait for full initialization
                sleep 10
                '''
            }
        }

        stage('Verify Deployment') {
            steps {
                sh '''
                echo "=== Container Status ==="
                docker compose ps -a
                echo "=== Testing Flask Endpoint ==="
                curl -I http://localhost:5000 || true
                '''
            }
        }
    }

    post {
        success {
            echo '🚀 Deployment successful!'
            sh 'docker compose ps'
        }
        failure {
            echo '❗ Pipeline failed. Check logs above.'
            sh '''
            echo "=== Error Investigation ==="
            docker compose logs --tail=50 || true
            '''
        }
        always {
            sh '''
            echo "=== Final Logs ==="
            docker compose logs --tail=20 || true
            '''
        }
    }
}


#Docker Push Is Included Below
pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "kastrov/devopsexamapp:latest"
    }

    stages {
        stage('Git Checkout') {
            steps {
                git url: 'https://github.com/KastroVKiran/devops-exam-app.git', 
                    branch: 'master'
            }
        }

        stage('Verify Docker Compose') {
            steps {
                sh '''
                docker compose version || { echo "Docker Compose not available"; exit 1; }
                '''
            }
        }

        stage('Build Docker Image') {
            steps {
                dir('backend') {
                    script {
                        withDockerRegistry(credentialsId: 'docker-creds', toolName: 'docker') {
                            sh "docker build -t ${DOCKER_IMAGE} ."
                        }
                    }
                }
            }
        }

        // NEW STAGE: Push to Docker Hub
        stage('Push to Docker Hub') {
            steps {
                script {
                    withDockerRegistry(credentialsId: 'docker-creds', toolName: 'docker') {
                        sh """
                        docker tag ${DOCKER_IMAGE} ${DOCKER_IMAGE}
                        docker push ${DOCKER_IMAGE}
                        """
                    }
                }
            }
        }

        stage('Deploy with Docker Compose') {
            steps {
                sh '''
                # Clean up any existing containers
                docker compose down --remove-orphans || true
                
                # Start services (no --build needed since we pre-built the image)
                docker compose up -d
                
                # Wait for MySQL to be ready
                echo "Waiting for MySQL to be ready..."
                timeout 120s bash -c '
                while ! docker compose exec -T mysql mysqladmin ping -uroot -prootpass --silent;
                do 
                    sleep 5;
                    docker compose logs mysql --tail=5 || true;
                done'
                
                # Additional wait for full initialization
                sleep 10
                '''
            }
        }

        stage('Verify Deployment') {
            steps {
                sh '''
                echo "=== Container Status ==="
                docker compose ps -a
                echo "=== Testing Flask Endpoint ==="
                curl -I http://localhost:5000 || true
                '''
            }
        }
    }

    post {
        success {
            echo '🚀 Deployment successful!'
            sh 'docker compose ps'
            sh 'docker images | grep devopsexamapp'  // Verify image exists
        }
        failure {
            echo '❗ Pipeline failed. Check logs above.'
            sh '''
            echo "=== Error Investigation ==="
            docker compose logs --tail=50 || true
            '''
        }
        always {
            sh '''
            echo "=== Final Logs ==="
            docker compose logs --tail=20 || true
            '''
        }
    }
}

----------------------------------------------------------K8S-----------------------
Step 1: Install AWS Credentials Plugin

Go to Manage Jenkins → Plugins.
Click the Available tab.
Search for "AWS Credentials".
Check the box and click Install without restart.
If it's already installed, it will appear under the "Installed" tab.

✅ Step 2: Add AWS Credentials After Plugin Install

Go to Manage Jenkins → Manage Credentials.
Select the appropriate scope (e.g., (global)).
Click Add Credentials.
Now you should see Kind: AWS Credentials.
Fill in:
Access Key ID
Secret Access Key
ID: aws-creds


1. Attach AmazonEBSCSIDriverPolicy to your worker node IAM role
Go to AWS Console → IAM → Roles

Find the role attached to your EC2 worker nodes (usually named like eksctl-<cluster>-NodeInstanceRole-...)

Click Attach policies

Search and select AmazonEBSCSIDriverPolicy

Click Attach policy

OR, if your EKS cluster is using EKS Managed Add-ons, and your nodes already have proper IAM permissions (after step 1), then you can just run:

bash
Copy
Edit
aws eks create-addon \
  --cluster-name devopsapp \
  --addon-name aws-ebs-csi-driver \
  --region <your-region>

kubectl get pods -n kube-system | grep ebs




Step 1: Attach AmazonEBSCSIDriverPolicy to the worker node role
This is the role that needs the permission:

Copy
Edit
eksctl-kastro-eks-nodegroup-node2-NodeInstanceRole-sKc0D0N1O1EP
👉 Attach the missing policy:
Go to AWS Console → IAM → Roles.

Search for eksctl-kastro-eks-nodegroup-node2-NodeInstanceRole-sKc0D0N1O1EP.

Click Attach policies.

Search for AmazonEBSCSIDriverPolicy.

Select it and click Attach policy.

✅ Step 2: Install the EBS CSI Driver Addon
Since you're using eksctl, the add-on can be installed via AWS CLI. Use this:

bash
Copy
Edit
aws eks create-addon \
  --cluster-name kastro-eks-cluster \
  --addon-name aws-ebs-csi-driver \
  --region <your-region>
Replace <your-region> (e.g., ap-south-1 or us-east-1) with your actual AWS region.

✅ Step 3: Verify EBS CSI is running
After 1–2 minutes, run:

bash
Copy
Edit
kubectl get pods -n kube-system | grep ebs
You should see pods like:

sql
Copy
Edit
ebs-csi-controller-xxxx   Running
ebs-csi-node-xxxxx        Running

pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "kastrov/devopsexamapp:latest"
        EKS_CLUSTER = "devopsapp"
        K8S_NAMESPACE = "devopsexamapp"
        AWS_REGION = "us-west-2"  // Update to your region
    }

    stages {
        // Existing stages (Git Checkout, Build, Push) remain the same
        
        stage('Deploy to EKS') {
            steps {
                script {
                    withCredentials([[
                        $class: 'AmazonWebServicesCredentialsBinding',
                        credentialsId: 'aws-creds',
                        accessKeyVariable: 'AWS_ACCESS_KEY_ID',
                        secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
                    ]]) {
                        sh """
                        # Configure EKS access
                        aws eks update-kubeconfig --name ${EKS_CLUSTER} --region ${AWS_REGION}
                        
                        # Create namespace if not exists
                        kubectl create namespace ${K8S_NAMESPACE} --dry-run=client -o yaml | kubectl apply -f -
                        
                        # Create image pull secret
                        kubectl create secret docker-registry dockerhub-creds \\
                            --docker-server=https://index.docker.io/v1/ \\
                            --docker-username=kastrov \\
                            --docker-password=\$(cat /var/jenkins_home/docker-creds/password) \\
                            --namespace=${K8S_NAMESPACE} \\
                            --dry-run=client -o yaml | kubectl apply -f -
                        
                        # Apply Kubernetes manifests from root
                        kubectl apply -f deployment.yml
                        kubectl apply -f service.yml
                        
                        # Verify deployment
                        kubectl rollout status deployment/devopsexamapp -n ${K8S_NAMESPACE}
                        """
                    }
                }
            }
        }
    }
}

# JupyterHub base deployment
This readme describes how to make a JupyterHub deployment on K8s 1.9

## Deployment description
| ---           | --- |
| :---          | ---: |
| Namespace     | erasmus |
| Description   | A deployment for the Erasmus deep learning course | 
| Contacts      | Haukur and Matthijs |
| Maintainer    | Haukur Pall Jonsson |
| Start date    | 19th February 2019 |
| End date      | 8th May 2019 |
| Cores         | 8 |
| Memory        | 16 GB |
| Storage       | 30 GB |
| #Users        | 60 |

### Deployment types
| Name | CPU | Memory |
| ---- | --- | ------ |
| Light | 1 | 3Gi |
| Medium | 2 | 6Gi |
| Heavy | 4 | 12Gi |

## Deployment procedure
1. Gather requirments from requester and document
  1. Fill in Deployment description.
  1. Is there a git repo to link to the deployment?
    1. Make sure that the repo is public.
  1. Should we create user accounts?
    1. Use https://git.ia.surfsara.nl/sda/jupyter/scripts/blob/master/jhuser
  1. What notebook is suiteable? Check [docker-stacks](http://interactive.blockdiag.com/image?compression=deflate&encoding=base64&src=eJyFzTEPgjAQhuHdX9Gws5sQjGzujsaYKxzmQrlr2msMGv-71K0srO_3XGud9NNA8DSfgzESCFlBSdi0xkvQAKTNugw4QnL6GIU10hvX-Zh7Z24OLLq2SjaxpvP10lX35vCf6pOxELFmUbQiUz4oQhYzMc3gCrRt2cWe_FKosmSjyFHC6OS1AwdQWCtyj7sfh523_BI9hKlQ25YdOFdv5fcH0kiEMA)
1. [Create a namespace in k8s](https://git.osd.surfsara.nl/big-data/kuberstein/tree/master/roles/users)
1. Create a new git repo by importing the [base](https://git.ia.surfsara.nl/sda/jupyter/instances/base/edit/master/readme.MD) repo
1. Edit values.yaml based on requirements. You should not have to edit the whole file.
    1. Update the portaladmin password: 
       `slappasswd -h {md5} -s 'pass' | base64` where the pass is, f.ex., from `pwgen -c -n -C 10`.
    1. Create a docker image if required. See below
1. Run source on https://git.ia.surfsara.nl/sda/jupyter/scripts/blob/master/kubecontext on the unarchieved folder. This will expose some environment variables and edit some of the files received.
1. Run upgrade.sh to deploy the environment (this relies on the `source` step).
1. If changes need to be made to the deployment, just edit the values file and run upgrade again. Worst case, delete the deployment and run it again
    1. helm delete $RELEASE_NAME --tiller-namespace $NAMESPACE --purge --tls
1. Create a gitlab ticket to take down the environment. Provide instructions:
    1. Contacts for the teardown.
    2. Either delete the helm deployment and notify Ops to clean-up the namespace OR login to admin01 and delete the namespace (prefered).
    3. Move repo to attic.
    4. Update the global deployments list [here](https://git.ia.surfsara.nl/sda/documentation/blob/master/readme.md)

## Creating a custom docker image
Create a `Dockerfile` in the same repo.
Build it locally first to test it
Create a .gitlab-ci.yml, so that we use a gitlab runner to build the image
The runner has access to the unsecure docker repository running on the cluster.
Optionally you can ssh into admin01 and build and push the image there.

TODO: Managing versions

## Testing the deployment (OLD)
- test logging in to the hub: https://base.jove.surfsara.nl test user: smoketest with password rM7G2-Uk
- test logging in to the portal: https://base-portal.jove.surfsara.nl user: portaladmin with password rM7G2-Uk -> As soon as logged in it is a good idea to change the password (note it down and communicate it to the end-user admin).
- test whether the api documentation is accessible: https://base-api.jove.surfsara.nl/usermgmtapi/

### Api key and application
<h6>Default</h6>

- X-API-Key: y5Xkv9VL/ySxPo9CNywuMqLgzjU=
- X-API-Application: jaas-ldap-api

<h6>Change API-Key</h6>

- edit values-usermgmtapi.yaml.template and set the api.secret value as desired.
- Redeploy or update the instance. Once restarted get the API-key from the api logs (kubectl logs --namespace=jupyter-base usermgmtapi-...-...)
things you should change/update between releases:
  - ldap root password (check all instance related values)
  - portal password (log in to portal and change password of portaladmin)
  - API-key


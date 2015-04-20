# Login to DockerHub

This role logs you into your DockerHub account. It needs to be run before you
pull any private images from DockerHub. You need to specify the credentials in
three ansible variables for this to work:

* `registry_user`
* `registry_password`
* `registry_email`

One way of doing that is to ask the user for credentials interactively, like
this:

```yml
vars_prompt:
  - name: registry_user
    prompt: "Docker Hub user name"
    private: no
  - name: registry_password
    prompt: "Docker Hub password"
    private: yes
  - name: registry_email
    prompt: "Docker Hub email"
    private: no
```

You can furthermore specify defaults like this:

```yml
vars_prompt:
  - name: registry_user
    prompt: "Docker Hub user name"
    default: poxar
    private: no
  - name: registry_password
    prompt: "Docker Hub password"
    private: yes
  - name: registry_email
    prompt: "Docker Hub email"
    default: philipp.millar@poxar.de
    private: no
```


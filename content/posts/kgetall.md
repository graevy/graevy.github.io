---
title: "kgetall"
date: 2026-03-07T01:35:33-08:00
draft: true
---

I have nothing poignant to say on this topic, but it's very funny to me

### What

`kubectl`, the only real k8s cli tool and frequent sysadmin cluster entrypoint, offers the `get` subcommand to "Display one or many resources" in a cluster. All kubernetes resources live in a namespace, have a type, and can be represented as text[^1]. Because kubernetes clusters are very stateful[^2], and tend to involve multiple people, enumerating the contents of a namespace (or all namespaces) is a helpful feature, especially for newer users, who might want to be peeking under the hood.

[Kubernetes documentation](https://kubernetes.io/docs/reference/kubectl/generated/kubectl_get/) doesn't actually mention `kubectl get all` under `kubectl get` at the time of writing. I will say no more. [Peek under the hood](https://feloy.medium.com/the-truth-about-kubectl-get-all-49cb533d8b8d) if you want.

## An Oral History of `kubectl get all` told through `kubernetes` and `kubectl` GitHub Issues

`kubectl` #113: [Need a command to list all available/existing types (or resources) in a cluster. Kubectl get all does not show all resources such as secrets](https://github.com/kubernetes/kubectl/issues/113).

[It is intended to not show Secrets when kubectl get all --all-namespaces](https://github.com/kubernetes/kubectl/issues/113#issuecomment-369650116)

[*closes your git issue* use `kubectl api-resources --verbs=list -o name | xargs -n 1 kubectl get -o name`](https://github.com/kubernetes/kubectl/issues/113#issuecomment-381333646)

Why didn't I think of that?

`kubernetes` #59561: [list custom resources in kubectl get all](https://github.com/kubernetes/kubernetes/issues/97347)

[`all` is for user facing resources. CRDs are highly privileged. They don't belong in the all list.](https://github.com/kubernetes/kubernetes/pull/59561#discussion_r166928655)

[Rather than have this change be made widely, there is a plugin that exists that provides this functionality.
https://github.com/corneliusweig/ketall. This is available now and wouldn't need to be added to the core of Kubernetes.](https://github.com/kubernetes/kubernetes/issues/97347#issuecomment-747670240)

[Using a plugin is great and is a good interim but to stick to the meaning of "all". kubectl get all should return all and not exclude anything because all means everything. Happy to work on it if considered worthwhile](https://github.com/kubernetes/kubernetes/issues/97347#issuecomment-747817323)

[I understand what you are saying but this discussion has happened in this thread #28955 (comment) and more recently in kubernetes/kubectl#151. It is clear that going forward that this will not be implemented. The provided plugin provides the mechanism to get "all" the resources per namespace.](https://github.com/kubernetes/kubernetes/issues/97347#issuecomment-747825395)

10 Thumbs down from the peanut gallery. There's just something so heartwarming about getting seven posts into an issue before mentioning that it's been discussed prior. Let's take a look at `kubectl` #151:

[kubectl get all does not list all resources in a namespace. As a user performing `kubectl get all` I expect to see all objects in the current context](https://github.com/kubernetes/kubectl/issues/151)

[Why is this closed? Some complex xargs stuff does not mitigate the fact at "all" is indeed a falsehood that does not return all objects.](https://github.com/kubernetes/kubectl/issues/151#issuecomment-410304193)

[all will not be extended because of compatibility concerns, and is not referenced in help any longer because it is misleading, as you point out](https://github.com/kubernetes/kubectl/issues/151#issuecomment-410306145)

[Is there some other literate way to "verb" all by label?](https://github.com/kubernetes/kubectl/issues/151#issuecomment-410309674)

[`kubectl api-resources --verbs=list --namespaced -o name | xargs -n 1 kubectl get --show-kind --ignore-not-found -l <label>=<value> -n <namespace>`. This also has the disadvantages of not only being unintuitive, but also slow as hell ...](https://github.com/kubernetes/kubectl/issues/151#issuecomment-439090322)

[that also doesn't work: error: unable to retrieve the complete list of server APIs: external.metrics.k8s.io/v1beta1: the server is currently unable to handle the request, metrics.k8s.io/v1beta1: the server is currently unable to handle the request](https://github.com/kubernetes/kubectl/issues/151#issuecomment-439162493)

As of `kubectl` github issue #151, complaining about `get all` is 3% of all `kubectl` issues. Here's #527:

[Need a real "get-all" command](https://github.com/kubernetes/kubectl/issues/527)

[`kubectl get all` is a legacy command and is actually implemented with a hardcoded server side list that is not easy to maintain. There is potential that it will be removed in the future and therefore will not be expanded upon or improved at this time.](https://github.com/kubernetes/kubectl/issues/527#issuecomment-675173747)

This one really gets me. "We can't remove this extremely common footgun because we'd have to append a string when we added a new resource type." I don't really buy "compatibility" as a reason for not adding things to `all` either; breaking changes happen, and I'm victim-blaming you. You knew what would happen when you shoved `all` inside a script.

Chaser:

[`kubectl delete --all` does not include uninitialized resources](https://github.com/kubernetes/kubernetes/issues/49035)

### `kgetall`

After staring at this `xargs` incantation I did eventually osmotically grasp that it does a k8s-apiserver `get` (with the auth and api discovery overhead) for each resource type. This is much faster:

```
kgetall() {
  kubectl get $(kubectl api-resources --verbs=list --namespaced -o name | grep -iv "^events" | paste -sd,) --show-kind --ignore-not-found "$@"
}
```

due to constructing a comma-separated list[^3] of resource types to grab in a single `kubectl get`. Currently I'm excluding events (which feel more debug-y than stateful) and usually passing `-A` for all namespaces.

When I organically encountered the edge cases of `kubectl delete` I also eventually wrote 

```
kkill() {
	if [[ $# -eq 2 ]]; then
      # case: cluster-wide non-namespaced resource 
		kubectl patch $1 $2 --type merge -p '{"metadata":{"finalizers":null}}'
	else
		kubectl -n $1 patch $2 $3 --type merge -p '{"metadata":{"finalizers":null}}'
	fi
}
```

which, while sloppier due to modality, and rarely used, I am also a little chuffed about.

### I don't have anything poignant to say

Explaining how I wrote a bash function that does what `kubectl get all` should do to my friend Finn at the ol' sysadmin stitch-and-bitch[^5] and he hits me with "you should write a blogpost about that, people love that shit, they'll hire you". Your move ^^

Codebase warts are funny to me. This one reminds me of generic erasure in Java for some reason[^4]. I'm sure the kubernetes people have gone back and forth on this many times and have perfectly valid reasons for `all` not meaning `all`, but I've also yet to see them.


[^1]: [this](https://garnaudov.com/writings/how-i-think-about-kubernetes/) is my favorite blogpost for top-down understanding kubernetes.

[^2]: I once accidentally applied a manifest without a namespace (landing it in the `default` namespace) which, if memory serves, included an `IngressRoute` (a custom resource definition provided by traefik) which broke a website (I think, because its corresponding `Service` resource referenced the wrong namespace?). I was only able to find it after exploring many of the beautiful solutions proposed in git issues above. Kubernetes is so stateful that in many clusters people will get mad at you for manually applying manifests because you're supposed to commit them and let gitops (flux or argo) control everything. It's like giving half a dozen sysadmins `wheel` on the same server.

[^3]: which would actually be a problem if my cluster had more than `$(getconf ARG_MAX)` resources (`2097152` at the moment)

[^4]: I think probably because it follows the same pattern of baked-in assumptions at the start of the codebase solved by clunky syntactical hurdles that everyone involved has to eventually just accept. Though `get all` is much easier to fix

[^5]: aka the [/dev/hack](https://devhack.net) open hack night


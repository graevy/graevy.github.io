---
title: "kgetall"
date: 2026-03-07T01:35:33-08:00
draft: false
---

While kvetching about this at the sysadmin stitch-n-bitch[^5] my friend says to me "you should write a blogpost, people love that shit, they'll hire you"

I have nothing poignant to say on this topic, but it's very funny to me

## Introduction 

The only real k8s cli tool and frequent sysadmin cluster entrypoint, `kubectl` offers the `get` subcommand to "Display one or many resources" in a cluster. All kubernetes resources live in a namespace, have a type, and can be represented as text[^1]. Because kubernetes clusters are very stateful[^2], and tend to involve multiple people, enumerating namespace contents is a helpful feature, especially for newer users absorbing information.

`kubectl get all` is a legacy subcommand. [Peek under the hood](https://feloy.medium.com/the-truth-about-kubectl-get-all-49cb533d8b8d) if you want. [Kubernetes documentation](https://kubernetes.io/docs/reference/kubectl/generated/kubectl_get/) no longer mentions `kubectl get all` under `kubectl get` because of...conflict. Please, dear reader, experience:


# An Oral History of `kubectl get all` told through `kubernetes` and `kubectl` GitHub Issues

#### `kubectl` #113: a humble beginning.

[1](https://github.com/kubernetes/kubectl/issues/113) Need a command to list all available/existing types (or resources) in a cluster. `kubectl get all` does not show all resources such as secrets.

[6](https://github.com/kubernetes/kubectl/issues/113#issuecomment-369650116) It is intended to not show Secrets when `kubectl get all --all-namespaces`.

[12](https://github.com/kubernetes/kubectl/issues/113#issuecomment-381333646) *closes your git issue* just use `kubectl api-resources --verbs=list -o name | xargs -n 1 kubectl get -o name`

Why didn't I think of that?

#### `kubectl` #151: center stage

The `kubectl get all` complaint cynosure. Legal precedent set here, hundreds of posts, you get it. As of #151, complaining about `get all` is 3% of all `kubectl` issues.

[1](https://github.com/kubernetes/kubectl/issues/151) `kubectl get all` does not list all resources in a namespace. As a user performing `kubectl get all` I expect to see all objects in the current context

[8](https://github.com/kubernetes/kubectl/issues/151#issuecomment-348206126) There are some rules about which resources must fall under "all", take a look [here](https://github.com/kubernetes/community/blob/master/contributors/devel/kubectl-conventions.md#rules-for-extending-special-resource-alias---all). Are the resources you want covered there?

[9](https://github.com/kubernetes/kubectl/issues/151#issuecomment-348215149) `kubectl help get` describes `kubectl get all` as "List all resources with different types". so I think I am right to expect all resources to be listed. It might be ok if adminstrative resources are hidden from a normal user. As a cluster admin I need an easy way to see everything in a namespace to decide if i can delete it or not.

[21](https://github.com/kubernetes/kubectl/issues/151#issuecomment-410304193) Why is this closed? Some complex xargs stuff does not mitigate the fact that "all" is indeed a falsehood that does not return all objects.

[22](https://github.com/kubernetes/kubectl/issues/151#issuecomment-410306145) `all` will not be extended because of compatibility concerns, and is not referenced in help any longer because it is misleading, as you point out

[23](https://github.com/kubernetes/kubectl/issues/151#issuecomment-410309674) Is there some other literate way to "verb" all by label?

[24](https://github.com/kubernetes/kubectl/issues/151#issuecomment-439090322) `kubectl api-resources --verbs=list --namespaced -o name | xargs -n 1 kubectl get --show-kind --ignore-not-found -l <label>=<value> -n <namespace>`. This also has the disadvantages of not only being unintuitive, but also slow as hell ...

[25](https://github.com/kubernetes/kubectl/issues/151#issuecomment-439162493) that also doesn't work: `error: unable to retrieve the complete list of server APIs: external.metrics.k8s.io/v1beta1: the server is currently unable to handle the request, metrics.k8s.io/v1beta1: the server is currently unable to handle the request`

#### `kubectl` #527: [Need a real "get-all" command](https://github.com/kubernetes/kubectl/issues/527)

[36](https://github.com/kubernetes/kubectl/issues/527#issuecomment-675173747) `kubectl get all` is a legacy command and is actually implemented with a hardcoded server side list that is not easy to maintain. There is potential that it will be removed in the future and therefore will not be expanded upon or improved at this time.

This one really gets me. "We can't remove this extremely common footgun because we'd have to append a string when we added a new resource type." I don't really buy "compatibility" as a reason for not adding things to `all` either; kubernetes does breaking changes, and I'm victim-blaming you. This is software. You knew what would happen when you shoved `all` into a script.

#### `kubernetes` #59561: [Allow to specify categories for custom resources](https://github.com/kubernetes/kubernetes/pull/59561)

[1](https://github.com/kubernetes/kubernetes/pull/59561#issue-295472121) ...so that we can get it working with `kubectl get all`.

[6](https://github.com/kubernetes/kubernetes/pull/59561#discussion_r166928655) `all` is for user facing resources. CRDs are highly privileged. They don't belong in the all list.

#### `kubernetes` #97347: [list custom resources in kubectl get all](https://github.com/kubernetes/kubernetes/issues/97347)

[3](https://github.com/kubernetes/kubernetes/issues/97347#issuecomment-746768909)  I am trying to understand the use for this. `kubectl api-resources` already shows the crds installed on the cluster. Also, some CRDs are not namespace-scoped and including these objects in `kubectl get all` would provide some issues where cluster objects are expressed in the namespace you are looking in.

[5](https://github.com/kubernetes/kubernetes/issues/97347#issuecomment-747670240) Rather than have this change be made widely, there is a plugin that exists that provides this functionality.
https://github.com/corneliusweig/ketall. This is available now and wouldn't need to be added to the core of Kubernetes.

[6](https://github.com/kubernetes/kubernetes/issues/97347#issuecomment-747817323) Using a plugin is great and is a good interim but to stick to the meaning of "all". `kubectl get all` should return all and not exclude anything because all means everything. Happy to work on it if considered worthwhile

[7](https://github.com/kubernetes/kubernetes/issues/97347#issuecomment-747825395) I understand what you are saying but this discussion has happened in this thread #28955 (comment) and more recently in kubernetes/kubectl#151. It is clear that going forward that this will not be implemented. The provided plugin provides the mechanism to get "all" the resources per namespace.

Ten Thumbs down. [6] is my favorite crashout. There's just something so heartwarming about getting seven posts into an issue before mentioning that it's been discussed prior. 

The people have largely given up. But `kubectl get all` cannot be slain:

#### `kubectl` #1584: [Remove get all entirely](https://github.com/kubernetes/kubectl/issues/1584)

[11](https://github.com/kubernetes/kubectl/issues/1584#issuecomment-2077449684) Due to backwards compatibility issues, I don't think we'll ever remove `get all` entirely. Yes, it will stay as deprecated and we'll continue recommending people to NOT using it. But we can't simply remove.

#### Chaser

[`kubectl delete --all` does not include uninitialized resources](https://github.com/kubernetes/kubernetes/issues/49035)[^9]

# `kgetall`

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

### I have one poignant thing to say on this topic

Codebase warts are funny. Every footgun has a story; too awkward to maintain, too load-bearing to remove. When enough of these accumulate, a software project develops a reputation for inaccessibility[^4]. I'm sure kubernetes people (kubers?) have a series of perfectly valid reasons for `all` not meaning `all`, but the cumulative effect seems indefensible.

New users want to see `all` so they can learn. Eventually, they learn more precise troubleshooting[^6], so the UX pattern becomes stackoverflow's "being told not to do what you're trying to do". Haunting these github issues, I see its shape: established users undervalue doing things incorrectly. Computer touchers consequently bias against tool learnability, probably due to our [familiarity with silicate geochemistry](https://xkcd.com/2501/), but also maybe our meritocracy. Neither the machine interfaces we work in[^8], nor the systems that employ us, prioritize our accommodation or accessibility. Left unchecked, why would our tooling?


[^1]: [this](https://garnaudov.com/writings/how-i-think-about-kubernetes/) is my favorite blogpost for top-down understanding kubernetes.

[^2]: It's very easy to accidentally leave something on a cluster. In most clusters I've collaborated in, people will get mad at you for manually applying manifests because you're supposed to commit them and let gitops (flux or argo) control everything. It's like giving half a dozen sysadmins `wheel` on the same server.

[^6]: People learn to not make the kinds of mistakes that accumulate cruft on a cluster. Example: I once accidentally applied a manifest without a namespace (landing it in the `default` namespace) which included a traefik CR `IngressRoute` which broke a website (details hazy). `kgetall` showed me the route, but now I would probably just jump straight to `kubectl get -A ingressroute,service | rg -i <thing>`. Also, to reiterate from [^2], gitops almost eliminates this problem class. I still have `kgetall` because of a few edges.

[^3]: which would actually be a problem if my cluster had more than `$(getconf ARG_MAX)` (`2097152` at the moment) bytes of resources

[^4]: This one reminds me of generic erasure in Java for some reason. I think probably because it follows the same pattern of baked-in assumptions at the start of the codebase solved by clunky syntactical hurdles that everyone involved has to eventually just accept. Though `get all` is much easier to fix

[^5]: aka the [/dev/hack](https://devhack.net) open hack night

[^7]: In that it's understandable why `kubectl get all` was made and (presumably) why it was left to rot. I give k8s the benefit of the doubt because software is notoriously bad at communicating about itself.

[^8]: Heidegger’s *enframing* describes how technological systems impose order on humans, who imagine themselves masters, yet become caught sustaining that order, ultimately experiencing subject-object inversion (postmodern philosophy context) via Günther Anders' *Promethean shame*

[^9]: while `kubectl delete` [won't delete an object with a finalizer](https://github.com/kubernetes/kubernetes/issues/95983) on it, even using `--force`, but it WILL schedule the object for deletion, and helpfully inform you that it has been deleted.


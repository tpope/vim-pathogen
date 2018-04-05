Follow the commit message guidelines at [commit.style](https://commit.style).
This is an absolute requirement for my repositories, and doing so proves you
actually read the contribution guidelines, which makes for a good first
impression.

Good commit messages imply good commits.  Pull requests should typically be a
single commit, or for the rare complicated case, a series of atomic commits.
If I request a change, use `git commit --amend` or `git rebase --interactive`
and force push to your branch.

For feature requests, don't be shy about proposing it in an issue before
drafting a patch.  If it's a great idea, I might do it for you.  If it's a
terrible idea, no patch will change my mind.

The worst ideas are configuration options.  You'll need to provide a great
justification in order to persuade me to take on the maintenance and support
burden it will inevitably entail.  See if you can get away with a custom map
or autocommand instead.

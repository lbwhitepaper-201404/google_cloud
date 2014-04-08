google_cloud Cookbook
=====================
TODO: Enter the cookbook description here.

e.g.
This cookbook makes your favorite breakfast sandwhich.

Requirements
------------
TODO: List your cookbook requirements. Be sure to include any requirements this cookbook has on platforms, libraries, other cookbooks, packages, operating systems, etc.

e.g.
#### packages
- `toaster` - google_cloud needs toaster to brown your bagel.

Attributes
----------
TODO: List you cookbook attributes here.

e.g.
#### google_cloud::default
<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>['google_cloud']['auth']['credential_file']</tt></td>
    <td>String</td>
    <td>
    A base64 encoded string of a tar file made of your ~/.config/gcloud directory.

    cd ~/.config
    tar -zcpf creds.tar.gz gcloud
    base64 creds.tar.gz >> creds.base64
    </td>
    <td><tt>nil</tt></td>
  </tr>
</table>

Usage
-----
#### google_cloud::default
TODO: Write usage instructions for each cookbook.

e.g.
Just include `google_cloud` in your node's `run_list`:

```json
{
  "name":"my_node",
  "run_list": [
    "recipe[google_cloud]"
  ]
}
```

Contributing
------------
TODO: (optional) If this is a public cookbook, detail the process for contributing. If this is a private cookbook, remove this section.

e.g.
1. Fork the repository on Github
2. Create a named feature branch (like `add_component_x`)
3. Write you change
4. Write tests for your change (if applicable)
5. Run the tests, ensuring they all pass
6. Submit a Pull Request using Github

License and Authors
-------------------
Authors: TODO: List authors

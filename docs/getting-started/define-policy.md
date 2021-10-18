# Define Policy

Now we'll create a Policy to enable connectivity between your tagged systems. Policies determine which systems can connect to each other, and which can't. Each Policy is composed of at least two Tags, one assigned to the `Sender` side of the policy, and the other the `Receiver` side of Policy.

Any systems which are members of Tags added to the `Sender` side of policy may originate traffic to any systems which are members of Tags added to the `Receiver` side of the same policy.

Depending on how you arrange the Tags in your Policy you can create either a partially connected or a fully connected mesh.

> **Production use:** This guide suggests creating some example policies. You can (and should) create policies which reflect the structure of your organisation for use in production. Visit the [Policy](/management/policy#naming) section of the handbook to learn more about creating, naming and managing policies.

=== "Partially connected mesh"

    In a partially connected mesh, only specific systems connect to one another.

    Here we'll define a policy that connects systems tagged with `org.workstations` to systems tagged with `org.servers`. Connectivity is established between the left and right sides of the policy (`Sender` to `Receiver`) but not between systems on the same side.

    1. In the Portal, navigate to the `Policies` page.
    2. Select the `Create a new policy` button and describe the new Policy as `Server Access`
    3. Add the `org.workstations` Tag to the Sender side of the policy.
    4. Add the `org.servers` Tag to the Receiver side of the policy.
    5. Save the policy.
    
        ![Illustration of how tags are applied to systems](/images/quick-start/policy-partially-connected-mesh.png)

    **Congratulations!** Your new policy will take effect immediately and Enclave will quickly build direct connectivity between your enrolled systems. You've successfully built your first Enclave connection.

=== "Fully connected mesh"

    In a fully connected mesh, all systems in the Policy are connected to one another

    Here we'll define a policy that connects any systems tagged with `org.any` to any other systems tagged with `org.any` to explicitly create a fully connected mesh.

    > **Production use:** Fully connected mesh networks may create large numbers of connections between participating systems. A fully connected mesh of 16 systems will create 120 connections, but a mesh with 32 participants will create 496 connections. You should consider the capabilities of your underlying network infrastructure when deploying a fully connected mesh. [Learn more](/management/policy#fully-connected-mesh).
    
    1. In the Portal, navigate to the `Policies` page.
    2. Select the `Create a new policy` button and describe the new Policy as `Full Mesh`
    3. Add the `org.any` Tag to the Sender side of the policy.
    4. Add the `org.any` Tag to the Receiver side of the policy.
    5. Save the policy.

        ![Illustration of how tags are applied to systems](/images/quick-start/policy-full-mesh.png)

    **Congratulations!** Your new policy will take effect immediately and Enclave will quickly build direct connectivity between your enrolled systems. You've successfully built your first Enclave connection.

Any future systems you enrol and attach these Tags to will automatically inherit the connectivity defined in this policy, helpful in auto-scaling scenarios to minimise the management overhead of connecting additional systems.

Now that you've got your first connection, see [next steps](/getting-started/next-steps) to learn more about what you can do with Enclave.
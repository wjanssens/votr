Ext.define('Votr.view.public.Ballots', {
    extend: 'Ext.Container',
    alias: 'widget.public.ballots',
    layout: 'vbox',
    padding: 0,
    controller: 'public.main',
    items: [
        {
            xtype: 'list',
            store: 'Ballots',
            listeners: {
                itemtap: 'onItemTap'
            },
            itemTpl: [
                '<tpl for=".">',
                '<div>',
                '  <img style="float: left; border: 1px solid black; margin-right: 16px; height: 80px; width: 80px; "src="../images/guy.png" />',
                '  <div style="float: right; height: 80px; padding: 2px;">',
                '    <span style="border-radius: 4px; border: 1px solid red; text-transform: uppercase; padding: 2px;">In Progress</span>',
                '  </div>',
                '  <div style="display: table;">',
                '    <h1 style="font-size: 1.25em; line-height: 1.5em; ">{title}</h1>',
                '    <h3 style="font-size: 1rem; line-height: 1.5em; color: var(--highlight-color);">{candidates.length} candidates, electing {electing}</h3>',
                '    <h2 style="font-size: 1rem; line-height: 1.5em; color: var(--highlight-color);">{description}</h2>',
                '  </div>',
                '</div>',
                '</tpl>'
            ]
        }
    ]
});
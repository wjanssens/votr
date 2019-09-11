Ext.define('Votr.view.index.Main', {
    extend: 'Ext.Panel',
    alias: 'widget.index.main',
    padding: 0,
    layout: 'hbox',
    scrollable: 'vertical',
    requires: [
        "Votr.view.index.MainController"
    ],
    controller: 'index.main',
    items: [
        {
            xtype: 'toolbar',
            itemId: 'toolbar',
            docked: 'top',
            items: [
                '->',
                {
                    xtype: 'button',
                    text: 'Pricing',
                    handler: 'onPricing'
                },
                {
                    xtype: 'button',
                    text: 'Docs',
                    handler: 'onDocs'
                },
                {
                    xtype: 'button',
                    text: 'Blog',
                    handler: 'onBlog'
                }
            ]
        }, {
            xtype: 'panel',
            flex: 1,
            layout: 'vbox',
            padding: 0,
            items: [
                {xtype: 'index.hero'},
                {xtype: 'index.features'},
                {xtype: 'index.stats'},
                {xtype: 'index.organizations'},
                {xtype: 'index.footer'}
            ]
        }
    ]
});

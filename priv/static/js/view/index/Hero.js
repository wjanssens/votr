Ext.define('Votr.view.index.Hero', {
    extend: 'Ext.Container',
    alias: 'widget.index.hero',
    padding: 16,
    layout: 'hbox',
    items: [
        {
            html: 'Hero',
            flex: 3
        },
        {
            xtype: 'index.login'
        }
    ]
});

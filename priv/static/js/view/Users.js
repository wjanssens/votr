Ext.define('Votr.view.Users', {
    extend: 'Ext.Panel',
    alias: 'widget.users',
    layout: 'hbox',
    padding: 0,
    items: [{
        xtype: 'list',
        width: 384,
        itemTpl: '<div><p>{title}<span style="float:right">{electing} / {candidates}</span></p><p style="color: var(--highlight-color)">{description}</p></div>',
        store: 'Users'
    }, {
        xtype: 'user',
        flex: 1
    }, {
        xtype: 'toolbar',
        itemId: 'toolbar',
        docked: 'bottom',
        items: [{
            xtype: 'button',
            itemId: 'back',
            iconCls: 'x-fa fa-plus',
            tooltip: 'Add User'
        }]
    }]
});
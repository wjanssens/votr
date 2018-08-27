Ext.define('Votr.view.admin.Candidates', {
    extend: 'Ext.Panel',
    alias: 'widget.admin.candidates',
    layout: 'hbox',
    padding: 0,
    items: [{
        xtype: 'list',
        width: 384,
        itemTpl: '<div><p>{name}<span style="float:right">{percentage * 100}%</span></p><p style="color: var(--highlight-color)">{desc}</p></div>',
        store: 'Candidates'
    }, {
        xtype: 'admin.candidate',
        flex: 1
    }, {
        xtype: 'toolbar',
        itemId: 'toolbar',
        docked: 'bottom',
        items: [{
            xtype: 'button',
            itemId: 'add',
            iconCls: 'x-fa fa-plus',
            tooltip: 'Add Candidate',
            handler: 'onAdd'
        }, '->', {
            xtype: 'button',
            itemId: 'save',
            text: 'Save',
            ui: 'action',
            handler: 'onSave'
        }]
    }]
});

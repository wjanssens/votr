Ext.define('Votr.view.admin.Ballots', {
    extend: 'Ext.Panel',
    alias: 'widget.admin.ballots',
    layout: 'hbox',
    padding: 0,
    requires: [
        "Votr.view.admin.BallotsController"
    ],
    controller: 'admin.ballots',
    items: [{
        xtype: 'list',
        width: 384,
        itemTpl: '<div><p>{title}<span style="float:right">{electing} / {candidates}</span></p><p style="color: var(--highlight-color)">{description}</p></div>',
        store: 'Ballots'
    }, {
        xtype: 'admin.ballot',
        flex: 1
    }, {
        xtype: 'toolbar',
        itemId: 'toolbar',
        docked: 'bottom',
        items: [{
            xtype: 'button',
            itemId: 'add',
            iconCls: 'x-fa fa-plus',
            tooltip: 'Add Ballot',
            handler: 'onAdd'
        }, {
            xtype: 'button',
            enableToggle: true,
            itemId: 'filter',
            iconCls: 'x-fa fa-filter',
            tooltip: 'Show All Ballots',
            handler: 'onFilter'
        }, '->', {
            xtype: 'button',
            itemId: 'candidates',
            text: 'Candidates',
            handler: 'onCandidates'
        }, {
            xtype: 'button',
            itemId: 'results',
            text: 'Results',
            handler: 'onResults'
        }, {
            xtype: 'button',
            itemId: 'log',
            text: 'Log',
            handler: 'onLog'
        }, {
            xtype: 'button',
            itemId: 'save',
            text: 'Save',
            ui: 'action',
            handler: 'onSave'
        }]
    }]
});
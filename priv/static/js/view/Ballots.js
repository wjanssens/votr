Ext.define('Votr.view.Ballots', {
    extend: 'Ext.Panel',
    alias: 'widget.ballots',
    layout: 'hbox',
    padding: 0,
    requires: [
        "Votr.view.BallotsController"
    ],
    controller: 'ballots',
    items: [{
        xtype: 'list',
        width: 384,
        itemTpl: '<div><p>{title}<span style="float:right">{electing} / {candidates}</span></p><p style="color: var(--highlight-color)">{description}</p></div>',
        store: 'Ballots'
    }, {
        xtype: 'ballot',
        flex: 1
    }, {
        xtype: 'toolbar',
        itemId: 'toolbar',
        docked: 'bottom',
        items: [{
            xtype: 'button',
            itemId: 'back',
            iconCls: 'x-fa fa-plus',
            tooltip: 'Add Ballot',
            handler: 'onAdd'
        }, {
            xtype: 'button',
            enableToggle: true,
            itemId: 'back',
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
        }]
    }]
});
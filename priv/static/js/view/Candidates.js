Ext.define('Votr.view.Candidates', {
    extend: 'Ext.Panel',
    alias: 'widget.candidates',
    layout: 'hbox',
    padding: 0,
    items: [{
        xtype: 'list',
        width: 384,
        itemTpl: '<div><p>{name}<span style="float:right">{percentage * 100}%</span></p><p style="color: var(--highlight-color)">{desc}</p></div>',
        store: 'Candidates'
    }, {
        xtype: 'candidate',
        flex: 1
    }, {
        xtype: 'toolbar',
        itemId: 'toolbar',
        docked: 'bottom',
        items: [{
            xtype: 'button',
            itemId: 'back',
            iconCls: 'x-fa fa-plus',
            tooltip: 'Add Candidate'
        }]
    }]
});

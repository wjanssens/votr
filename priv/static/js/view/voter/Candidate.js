Ext.define('Votr.view.voter.Candidate', {
    extend: 'Ext.panel.Panel',
    alias: 'widget.voter.candidate',
    layout: 'hbox',
    border: 1,
    items: [{
        xtype: 'panel',
        flex: 1,
        padding: 0,
        layout: 'vbox',
        items: [{
            padding: 0,
            xtype: 'panel',
            style: 'font-size: 1.5em;',
            html: 'Name'
        },{
            padding: 0,
            xtype: 'panel',
            html: 'Description'
        }]
    },{
        xtype: 'voter.rankfield'
    }]
});
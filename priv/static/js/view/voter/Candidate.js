Ext.define('Votr.view.voter.Candidate', {
    extend: 'Ext.panel.Panel',
    alias: 'widget.voter.candidate',
    layout: 'hbox',
    padding: 0,
    border: 1,
    items: [{
        xtype: 'panel',
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
        xtype: 'panel',
        width: 32
    }]
});
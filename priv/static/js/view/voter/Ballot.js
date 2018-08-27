Ext.define('Votr.view.voter.Ballot', {
    extend: 'Ext.panel.Panel',
    alias: 'widget.voter.ballot',
    layout: 'vbox',
    width: 512,
    border: 1,
    padding: 0,
    items: [{
        xtype: 'panel',
        title: 'Title',
        items: [{
            xtype: 'voter.candidate'
        },{
            xtype: 'voter.candidate'
        }]
    }]
});
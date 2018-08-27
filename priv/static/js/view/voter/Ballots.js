Ext.define('Votr.view.voter.Ballots', {
    extend: 'Ext.panel.Panel',
    alias: 'widget.voter.ballots',
    layout: 'vbox',
    pack: 'center',
    items: [{
        xtype: 'voter.ballot'
    },{
        xtype: 'voter.ballot'
    }]
});
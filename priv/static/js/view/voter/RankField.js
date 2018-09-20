Ext.define('Votr.view.voter.RankField', {
    extend: 'Ext.panel.Panel',
    alias: 'widget.voter.rankfield',
    layout: 'hbox',
    data: { rank: 0, max: 0, ranked: true, widthdrawn: false },
    setData: function(data) {
        this.callParent(arguments);
        this.down('#value').setData(data);
        this.down('#increment').setDisabled(data.withdrawn);
        this.down('#decrement').setDisabled(data.withdrawn);
    },
    getMax: function() {
        return this.getData().max;
    },
    getRank: function() {
        return this.getData().rank;
    },
    setRank: function(rank) {
        var data = this.getData();
        if (rank >= 0 && (data.max == null || rank <= data.max)) {
            var oldValue = data.rank;
            data.rank = rank;
            this.setData(data);
            this.fireEvent('rank', rank, oldValue);
        }
    },
    increment: function() {
        var data = this.getData();
        this.setRank(data.rank + 1);
    },
    decrement: function() {
        var data = this.getData();
        this.setRank(data.rank - 1);
    },
    items: [{
        xtype: 'button',
        itemId: 'decrement',
        text: '–',
        style: 'font-size: 2em; text-align: center;',
        height: 48,
        width: 48,
        handler: function() { this.up().decrement(); }
    },{
        xtype: 'component',
        itemId: 'value',
        tpl: new Ext.XTemplate(
            '<tpl for=".">',
                '<tpl if="rank == 0"><p style="height: 100%; border: 1px solid black;"></p></tpl>',
                '<tpl if="ranked && rank &gt; 0"><p style="height: 100%; border: 1px solid black; padding-top: 14px;">{rank}</p></tpl>',
                '<tpl if="!ranked && rank &gt; 0"><p style="height: 100%; border: 1px solid black; padding-top: 14px;">&cross;</p></tpl>',
            '</tpl>'
        ),
        style: 'font-size: 2em; text-align: center; height: 100%; vertical-align: middle;',
        border: true,
        styleHtmlContent: false,
        readOnly: true,
        height: 48,
        width: 48,
    },{
        xtype: 'button',
        itemId: 'increment',
        text: '+',
        style: 'font-size: 2em; text-align: center;',
        height: 48,
        width: 48,
        handler: function() { this.up().increment(); }
    }]
});
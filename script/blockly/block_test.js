Blockly.Blocks['stuff_date'] = {
  init: function() {
    this.setHelpUrl('http://www.example.com/');
    this.setColour(20);
    this.appendDummyInput()
        .appendField("mostra data");
    this.setPreviousStatement(true);
    this.setNextStatement(true);
    this.setTooltip('');
  }
};

Blockly.JavaScript['stuff_date'] = function(block) {
  // TODO: Assemble JavaScript into code variable.
  var code = 'alert(Date())';
  return code;
};

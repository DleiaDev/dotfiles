--local bufnr = vim.fn.bufnr()
--local term = vim.api.nvim_open_term(bufnr, {})
--vim.api.nvim_chan_send(term, 'ls -al')

vim.fn.jobstart({ 'ls', '-al' }, {
  on_stdout = function(jobId, data, event)
    print(jobId, data, event)
  end
})

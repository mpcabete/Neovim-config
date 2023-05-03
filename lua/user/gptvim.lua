print('gptvim loaded')
vim.api.nvim_create_user_command("Gpt", function()
  local buffnr = vim.api.nvim_get_current_buf()
  local cursor = vim.api.nvim_win_get_cursor(0)
  local promptLineN = cursor[1]
  local currentLineN = promptLineN
  local promptLine = vim.api.nvim_buf_get_lines(buffnr,currentLineN-1,currentLineN,false)[1]
  local filetype = vim.filetype.match({buf=buffnr})

  --insert new line
  vim.api.nvim_buf_set_lines(buffnr,currentLineN,currentLineN,false,{""})
  vim.fn.jobstart({"gptcode",filetype,promptLine},{
      on_stdout = function(_,data)
      local lineLength = #vim.api.nvim_buf_get_lines(buffnr,currentLineN,currentLineN+1,false)[1]
      -- if gptcode returns newline data will splite those incomplete lines in two items, set text will then split it
      vim.api.nvim_buf_set_text(buffnr,currentLineN,lineLength,currentLineN,lineLength,data)
      if #data > 1 then
        currentLineN = currentLineN+1
      end
    end

  })


end,{})


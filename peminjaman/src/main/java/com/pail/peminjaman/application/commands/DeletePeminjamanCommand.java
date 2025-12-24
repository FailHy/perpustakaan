package com.pail.peminjaman.application.commands;

import com.pail.peminjaman.application.Command;
import com.pail.peminjaman.dto.CommandResult;

/**
 * Command for deleting a Peminjaman
 * Returns CommandResult (CQRS compliant)
 */
public class DeletePeminjamanCommand implements Command<CommandResult> {
    private final Long id;

    public DeletePeminjamanCommand(Long id) {
        this.id = id;
    }

    public Long getId() {
        return id;
    }
}

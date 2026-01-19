package com.pail.peminjaman.application.queries;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import com.pail.peminjaman.application.Query;
import com.pail.peminjaman.application.QueryHandler;
import com.pail.peminjaman.dto.PeminjamanDTO;
import com.pail.peminjaman.repository.PeminjamanRepository;

/**
 * Query for getting Peminjaman by ID
 * Returns DTO, not raw entity (CQRS compliant)
 */
public class GetPeminjamanByIdQuery implements Query<PeminjamanDTO> {
    private final Long id;

    public GetPeminjamanByIdQuery(Long id) {
        this.id = id;
    }

    public Long getId() {
        return id;
    }
}

/**
 * Handler for GetPeminjamanByIdQuery
 */
@Component
class GetPeminjamanByIdHandler implements QueryHandler<GetPeminjamanByIdQuery, PeminjamanDTO> {

    @Autowired
    private PeminjamanRepository peminjamanRepository;

    @Override
    public PeminjamanDTO handle(GetPeminjamanByIdQuery query) {
        return peminjamanRepository.findById(query.getId())
                .map(PeminjamanDTO::fromEntity)
                .orElse(null);
    }
}

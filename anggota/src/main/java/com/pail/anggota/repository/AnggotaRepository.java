package com.pail.anggota.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import com.pail.anggota.model.AnggotaModel;
import org.springframework.stereotype.Repository;

@Repository
public interface AnggotaRepository extends JpaRepository<AnggotaModel, Long> {

}

package com.mind_your.mind.controllers;

import com.mind_your.mind.dto.request.AgendaRequestDTO;
import com.mind_your.mind.dto.response.AgendaResponseDTO;
import com.mind_your.mind.service.AgendaService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/agendas")
public class AgendaController {

    @Autowired
    private AgendaService agendaService;

    @PostMapping
    public ResponseEntity<AgendaResponseDTO> agendar(@RequestBody AgendaRequestDTO dto) {
        return ResponseEntity.ok(agendaService.agendar(dto));
    }

    @GetMapping("/psicologo/{psicologoId}")
    public ResponseEntity<List<AgendaResponseDTO>> listarDoPsicologo(@PathVariable("psicologoId") String psicologoId) {
        return ResponseEntity.ok(agendaService.listarDoPsicologo(psicologoId));
    }

    @GetMapping("/paciente/{pacienteId}")
    public ResponseEntity<List<AgendaResponseDTO>> listarDoPaciente(@PathVariable("pacienteId") String pacienteId) {
        return ResponseEntity.ok(agendaService.listarDoPaciente(pacienteId));
    }

    @PutMapping("/{id}/cancelar")
    public ResponseEntity<Void> cancelar(@PathVariable("id") String id) {
        agendaService.cancelar(id);
        return ResponseEntity.noContent().build();
    }
}

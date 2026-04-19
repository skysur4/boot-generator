package ${package}.common.entity;

import com.fasterxml.jackson.annotation.JsonFormat;
import jakarta.persistence.*;
import ${package}.common.context.UserContext;
import org.springframework.http.HttpStatus;

import lombok.Getter;

import java.time.LocalDateTime;

@Getter
@MappedSuperclass
public abstract class BaseEntity {

    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd HH:mm:ss.SSS")
    @Column(name = "created_at", updatable = false)
    protected LocalDateTime createdAt;

    @Column(name = "created_by", updatable = false)
    protected String createdBy;

    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd HH:mm:ss.SSS")
    @Column(name = "updated_at")
    protected LocalDateTime updatedAt;

    @Column(name = "updated_by")
    protected String updatedBy;

    @Transient
    protected HttpStatus status = HttpStatus.PROCESSING;

    @PrePersist
    private void beforeInsertion(){
        this.createdAt = LocalDateTime.now();
        this.createdBy = UserContext.getId();
        this.updatedAt = LocalDateTime.now();
        this.updatedBy = UserContext.getId();
    }

    @PreUpdate
    private void beforeModification(){
        this.updatedAt = LocalDateTime.now();
        this.updatedBy = UserContext.getId();
    }

    @PostPersist
    private void afterInsertion(){
        this.status = HttpStatus.CREATED;
    }

    @PostUpdate
    private void afterModification(){
        this.status = HttpStatus.OK;
    }

    @PostRemove
    private void afterDeletion(){
        this.status = HttpStatus.NO_CONTENT;
    }

}